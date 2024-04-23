import 'package:flutter/material.dart';
import 'package:clinicease/models/book_service_model.dart'; 
import 'package:clinicease/services/services_service.dart'; 

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({Key? key}) : super(key: key);

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final BookedServiceService _bookedServiceService = BookedServiceService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
      ),
      body: FutureBuilder(
        future: _bookedServiceService.getBookedServices(),
        builder: (context, AsyncSnapshot<List<BookedServiceModel>> snapshot) {
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
                final bookedService = snapshot.data![index];
                return ListTile(
                  // leading: Image.network(
                  //   bookedService.imageUrl!,
                  //   width: 50,
                  //   height: 50,
                  // ),
                  title: Text(bookedService.fullName.toString()),
                  subtitle: Text(
                    'Date: ${bookedService.serviceDate.toString()}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle button press action (if needed)
                    },
                    child: const Text('View Details'),
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
