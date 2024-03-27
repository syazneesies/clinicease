import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/service_model.dart';

class RewardService {
  final CollectionReference serviceCollection =
      FirebaseFirestore.instance.collection('services');

  Future<List<ServiceModel>> getServices() async {
    List<ServiceModel> services = [];

    try {
      QuerySnapshot querySnapshot = await serviceCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        ServiceModel service = ServiceModel.fromJson(data);
        services.add(service);
      }
    } catch (e) {
      print("Error getting services: $e");
    }

    return services;
  }
}
