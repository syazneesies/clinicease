import 'package:clinicease/models/book_service_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/service_model.dart';

//Get all thes service data
class ServiceService {
  final CollectionReference serviceCollection =
      FirebaseFirestore.instance.collection('services');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 Future<List<ServiceModel>> getServices() async {
  List<ServiceModel> services = [];
  
  try {
    QuerySnapshot? querySnapshot = await serviceCollection.get();
    if (querySnapshot != null) {
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ServiceModel service = ServiceModel.fromJson(data);
        service.serviceId = doc.id;
        services.add(service);

        // Add debug output to display the retrieved data
        print("Retrieved service: $service");
      }
    } else {
      print("QuerySnapshot is null");
    }
  } catch (e) {
    // Handle specific errors that might occur during the get() call
    print("Error getting services: $e");
  }

  return services;
}

  // Retrieve service data by UID from Firestore
  Future<ServiceModel?> getServiceData(String serviceUID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('services').doc(serviceUID).get();

      if (documentSnapshot.exists) {
        // Service data found, parse it into UserModel
        Map<String, dynamic> serviceData = documentSnapshot.data() as Map<String, dynamic>;
        ServiceModel service = ServiceModel.fromJson(serviceData);
        service.serviceId = documentSnapshot.id;
        return service;
      } else {
        // Service data not found
        return null;
      }
    } catch (e) {
      // Error occurred while fetching user data
      print("Error fetching service data: $e");
      return null;
    }
  }

  // Save booking details to Firestore
  Future<void> saveBookingDetails(Map<String, dynamic> bookingData) async {
    try {
      // Add the booking details to the 'booked_services' collection
      await _firestore.collection('booked_services').add(bookingData);

      // Show success message or handle success as needed
      print('Booking saved successfully');
    } catch (error) {
      // Show error message or handle error as needed
      print('Failed to save booking: $error');
    }
  }

    Future<void> updateServiceQuantity(String serviceId) async {
    try {
      await serviceCollection.doc(serviceId).update({
        'serviceQuantity': FieldValue.increment(-1),
      });
    } catch (e) {
      print("Error updating service quantity: $e");
      throw e;
    }
  }
}

class BookedServiceService {
  final CollectionReference _bookedServiceCollection =
      FirebaseFirestore.instance.collection('booked_services');

Future<List<BookedServiceModel>> getBookedServices(String userId) async {
  List<BookedServiceModel> bookedServices = [];

  try {
    QuerySnapshot querySnapshot = await _bookedServiceCollection.where('userId', isEqualTo: userId).get();
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      BookedServiceModel bookedService = BookedServiceModel.fromJson(data);
      bookedService.booked_serviceId = doc.id;
      bookedServices.add(bookedService);
    }
  } catch (e) {
    print("Error getting booked services: $e");
  }

  return bookedServices;
}

  Future<BookedServiceModel> getBookedServiceDetails(String bookingId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _bookedServiceCollection.doc(bookingId).get();
      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;
        BookedServiceModel bookedService = BookedServiceModel.fromJson(data);
        bookedService.booked_serviceId = documentSnapshot.id;
        return bookedService;
      } else {
        throw Exception('Booking not found');
      }
    } catch (e) {
      print("Error fetching booked service details: $e");
      throw e;
    }
  }
}

