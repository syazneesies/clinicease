import 'package:flutter/material.dart';
import 'package:clinicease/models/book_service_model.dart';
import 'package:clinicease/services/services_service.dart';
import 'package:clinicease/helpers/date_time_utils.dart';
import 'package:clinicease/screen/my_booking_detail_screen.dart';

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
        title: const Text('My Bookings History'),
      ),
      body: FutureBuilder<List<BookedServiceModel>>(
        future: _bookedServiceService.getBookedServices(),
        builder: (context, snapshot) {
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
                return Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(bookedService.fullName ?? 'N/A'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${bookedService.serviceName ?? 'N/A'}'),
                              Text('Date: ${formatDate(bookedService.serviceDate)}'),
                              Text('Time: ${formatTimeAMPM(bookedService.serviceTimes)}'),
                            ],
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => BookingDetailScreen(bookingId: bookedService.booked_serviceId!), // Use the correct property
                                ),
                              );
                            },
                            child: const Text('View Details'),
                          ),
                        ),
                      ],
                    ),
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
