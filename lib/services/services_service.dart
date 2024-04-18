import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/service_model.dart';

class ServiceService {
  final CollectionReference serviceCollection =
      FirebaseFirestore.instance.collection('services');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ServiceModel>> getServices() async {
    List<ServiceModel> services = [];

    try {
      QuerySnapshot querySnapshot = await serviceCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ServiceModel service = ServiceModel.fromJson(data);
        service.serviceId = doc.id;
        services.add(service);
      }
    } catch (e) {
      print("Error getting services: $e");
    }

    return services;
  }

  // Retrieve service data from Firestore
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
}


