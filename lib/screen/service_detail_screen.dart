import 'package:clinicease/screen/service_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/services/services_service.dart';
//import 'package:clinicease/screen/edit_service_screen.dart'; // Import the edit service screen

class ServiceDetailScreen extends StatefulWidget {
  const ServiceDetailScreen({Key? key, required this.serviceId}) : super(key: key);

  final String serviceId;

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  late Future<ServiceModel?> _serviceDataFuture;
  final ServiceService _serviceService = ServiceService(); 

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  onRefresh() {
    setState(() {
      _serviceDataFuture = _serviceService.getServiceData(widget.serviceId); 
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
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      service.imageUrl!,
                      width: 200,
                      height: 200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Card(
                      elevation: 4, // Add elevation for shadow effect
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10), // Rounded corners
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(service.serviceName!.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                            Text(service.serviceDescription!),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Service Information', style: Theme.of(context).textTheme.subtitle1),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Display service details here
                            // Replace this with your actual service details widget
                            // Below are placeholders, replace them with actual service details
                            Text('Service Date: ${service.serviceDate.toString()}'),
                            // Add more widgets to display other service details
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: ElevatedButton(
                      onPressed: () {
                        print('id: ${service.serviceId!}');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ServiceConfirmationScreen(
                            serviceId: service.serviceId!,
                          ),
                        ));
                      },
                      child: const Text('Book Now'),
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
