import 'package:clinicease/screen/service_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/services/services_service.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({Key? key}) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final ServiceService _serviceService = ServiceService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service List'),
      ),
      body: FutureBuilder(
        future: _serviceService.getServices(),
        builder: (context, AsyncSnapshot<List<ServiceModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final service = snapshot.data![index];
                return ListTile(
                  leading: Image.network(
                    service.imageUrl!,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(service.serviceName!),
                  subtitle: Text(
                    'Date: ${service.serviceDate.toString()} Quantity: ${service.serviceQuantity.toString()}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // print('Service ID: ${service.toJson()}');
                      // print('Service ID: ${service.serviceId}');
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ServiceDetailScreen(serviceId: service.serviceId!),
                      ));
                    },
                    child: const Text('Book Now'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
