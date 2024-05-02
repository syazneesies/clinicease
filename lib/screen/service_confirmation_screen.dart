import 'package:clinicease/models/branch_model.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/services/branch_service.dart';
import 'package:clinicease/services/services_service.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ServiceConfirmationScreen extends StatefulWidget {
  const ServiceConfirmationScreen({super.key, required this.serviceId});
  final String serviceId;

  @override
  State<ServiceConfirmationScreen> createState() => _ServiceConfirmationScreenState();
}

class _ServiceConfirmationScreenState extends State<ServiceConfirmationScreen> {
  final BranchService _branchService = BranchService();
  final ServiceService _serviceService = ServiceService();
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  BranchModel? selectedBranch;
  ServiceModel? service;

  late UserModel? user;
  List<BranchModel> branches = [];
  late List<DateTime> timeOptions;
  bool isLoading = false;
  String? userId;
  @override
  void initState() {
    super.initState();
    userId = StorageService.getUID();
    user = StorageService.getUserData();
    fullNameController.text = user!.fullName!;
    phoneNumberController.text = user!.phoneNumber!;
    getBranches();
    getService();
  }


  getBranches() async {
    setState(() => isLoading = true);
    branches = await _branchService.getBranches();
    for (var b in branches) {
      print('${b.branchName}');
    }
    setState(() => isLoading = false);
  }

  getService() async {
  setState(() => isLoading = true);
  service = await _serviceService.getServiceData(widget.serviceId);
  timeOptions = service!.serviceTimes;
  setState(() => isLoading = false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Appointment'),
      ),
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Service Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: Icon(Icons.badge, size: 32, color: Colors.purple.shade900),
                      title: Text(service?.serviceName ?? 'Service Name'),
                      subtitle: const Text('Service Name'),
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, size: 32, color: Colors.purple.shade900),
                      title: Text(service != null ? DateFormat('dd-MM-yyyy').format(service!.serviceDate!) : 'Service Date'),
                      subtitle: const Text('Service Date'),
                      contentPadding: const EdgeInsets.all(0),
                    ),
                  ],
                ),
              ),
            
              // Title
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      
              const SizedBox(height: 20),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
              ),

              // Title
              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Booking Appointment Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              DropdownButtonFormField<DateTime>(
              value: null,
              decoration: const InputDecoration(
                labelText: 'Time',
                border: OutlineInputBorder(),
              ),
              items: timeOptions.map((time) {
                return DropdownMenuItem<DateTime>(
                  value: time,
                  child: Text(time.toString()), 
                );
              }).toList(),
              onChanged: (selectedTime) {
                setState(() {
                  timeController.text = selectedTime!.toString();
                });
              },
            ),


              // Create branch dropdown
              const SizedBox(height: 10),
              DropdownButtonFormField<BranchModel>(
                value: null,
                decoration: const InputDecoration(
                  labelText: 'Branch',
                  border: OutlineInputBorder(),
                ),
                items: branches.map<DropdownMenuItem<BranchModel>>((branch) {
                  return DropdownMenuItem<BranchModel>(
                    value: branch,
                    child: Text(branch.branchName!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedBranch = value;
                  });
                },
              )
            ]
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
          onPressed: () async {
          if (service != null && selectedBranch != null && service!.serviceDate != null && user != null) {
            DateTime selectedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss.S').parse('${service!.serviceDate} ${timeController.text}');
            // Prepare booking data
            Map<String, dynamic> bookingData = {
              'serviceName': service!.serviceName,
              'serviceDate': Timestamp.fromDate(service!.serviceDate!),
              'fullName': fullNameController.text,
              'phoneNumber': phoneNumberController.text,
              'selectedBranch': selectedBranch!.toJson(), // Assuming toJson() method is implemented in BranchModel
              'serviceTimes': Timestamp.fromDate(selectedDateTime),
              'userId': userId, // Assuming id is available in UserModel
              'serviceId': service!.serviceId, // Assuming serviceId is available in ServiceModel
              'createdAt': FieldValue.serverTimestamp(), // Include server timestamp for createdAt
            };

            // Print booking data to console
            print('Booking Data: $bookingData');
            
            try {
              // Update service quantity
              await ServiceService().updateServiceQuantity(service!.serviceId!);

              // Call ServiceService to save booking details
              await ServiceService().saveBookingDetails(bookingData);

              // Show success message or handle success as needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking saved successfully')),
              );

              // Pop the screen
              Navigator.of(context).pop();
            } catch (e) {
              // Handle error
              print("Error saving booking details: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Unable to save booking details')),
              );
            }
          } else {
            // Handle null values
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Some data is null')),
            );
          }
        },
          child: const Text('Save'),
        ),

        ),
      )    
    );
  }
}