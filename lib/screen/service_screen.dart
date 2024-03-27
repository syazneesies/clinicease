import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/service_model.dart';
import 'package:clinicease/services/services_service.dart';
//import 'package:clinicease/screens/service_detail_screen.dart';

class ServiceScreen extends StatefulWidget {
  @override
  _ServiceScreenState createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  final RewardService _serviceService = RewardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Service List'),
      ),
      body: FutureBuilder(
        future: _serviceService.getServices(),
        builder: (context, AsyncSnapshot<List<Service>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                    service.imageUrl,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(service.serviceName),
                  subtitle: Text(
                    'Date: ${service.serviceDate.toString()} Quantity: ${service.serviceQuantity.toString()}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyProfileScreen(),
                        //serviceId: service.id
                      ));
                    },
                    child: Text('Book Now'),
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
