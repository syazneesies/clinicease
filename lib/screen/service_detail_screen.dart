import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/services/services_service.dart';
//import 'package:clinicease/screen/edit_service_screen.dart'; // Import the edit service screen

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({Key? key}) : super(key: key);

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late Future<ServiceModel?> _serviceDataFuture;
  final ServiceService _serviceService = ServiceService(); 
  String? serviceId;

  @override
  void initState() {
    super.initState();
    serviceId = StorageService.getUID(); 

    onRefresh();
  }

  onRefresh() {
  setState(() {
    _serviceDataFuture = _serviceService.getServiceData(serviceId!); 
  });

  _serviceDataFuture.then((service) {
    if (service != null) {
      print('Service UID fetched: ${service.serviceId}');
    } else {
      print('Service data not found');
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Info'),
      ),
      body: FutureBuilder<ServiceModel?>(
        future: _serviceDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final service = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Display service information here
                        // Assuming service.imageUrl contains the service image URL
                        // Replace this with your actual image loading widget
                        Image.network(
                          service.imageUrl!,
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 24),
                        Text(service.serviceName!.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                        Text(service.serviceDescription!),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Service Information', style: Theme.of(context).textTheme.subtitle1),
                            TextButton(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => const MyProfileScreen(),
                                ),
                              ).then((value) {
                                if (value != null) {
                                  onRefresh();
                                }
                              }),
                              child: const Text('Edit'),
                            ),
                          ],
                        ),
                        // Display service details here
                        // Replace this with your actual service details widget
                        // Below are placeholders, replace them with actual service details
                        Text('Service Description: ${service.serviceDescription}'),
                        Text('Service Date: ${service.serviceDate.toString()}'),
                        Text('Service Quantity: ${service.serviceQuantity.toString()}'),
                        // Add more widgets to display other service details
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('No service data found'));
          }
        },
      ),
    );
  }
}
