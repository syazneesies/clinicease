import 'package:clinicease/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/book_service_model.dart';
import 'package:clinicease/services/services_service.dart';
import 'package:clinicease/helpers/date_time_utils.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({Key? key, required this.bookingId}) : super(key: key);

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  final BookedServiceService _bookedServiceService = BookedServiceService();
  late Future<BookedServiceModel> _bookingFuture;

  @override
  void initState() {
    super.initState();
    _bookingFuture = _bookedServiceService.getBookedServiceDetails(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Detail'),
      ),
      body: FutureBuilder<BookedServiceModel>(
        future: _bookingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final booking = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Booking Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Service Name: ${booking.serviceName ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Full Name: ${booking.fullName ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Phone Number: ${booking.phoneNumber ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Date: ${formatDate(booking.serviceDate)}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Time: ${formatTime(booking.serviceTimes)}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: QrImageView(
                      data: widget.bookingId,
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      },
                      child: Text('Go to Home'),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Booking not found.'));
          }
        },
      ),
    );
  }
}
