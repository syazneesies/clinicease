import 'package:clinicease/screen/service_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/services/services_service.dart';
import 'package:intl/intl.dart';

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.serviceName!.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              service.serviceDescription!,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 24),
                            // Display service details
                            Text('Doctor In Charge: ${service.servicePIC}'),
                            SizedBox(height: 8),
                            Text('Available Slots: ${service.serviceQuantity}'),
                            SizedBox(height: 8),
                            Text('Available Time:'),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: service.serviceTimes!.map<Widget>((timeStamp) {
                                // Format the timestamp into a readable string
                                final formattedTime = DateFormat('h:mm a').format(timeStamp);
                                return Text('- $formattedTime');
                              }).toList(),
                            ),
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
