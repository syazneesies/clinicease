import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/reward_model.dart';

class RewardService {
  final CollectionReference rewardCollection =
      FirebaseFirestore.instance.collection('rewards');
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<RewardModel>> getRewards() async {
    List<RewardModel> rewards = [];

    try {
      QuerySnapshot querySnapshot = await rewardCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        RewardModel reward = RewardModel.fromJson(data);
        rewards.add(reward);
      }
    } catch (e) {
      print("Error getting services: $e");
    }

    return rewards;
  }

// Retrieve reward data from Firestore
  Future<RewardModel?> getServiceData(String rewardUID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('rewards').doc(rewardUID).get();

      if (documentSnapshot.exists) {
        // Service data found, parse it into UserModel
        Map<String, dynamic> rewardData = documentSnapshot.data() as Map<String, dynamic>;
        return RewardModel.fromJson(rewardData);
      } else {
        // Service data not found
        return null;
      }
    } catch (e) {
      // Error occurred while fetching user data
      print("Error fetching reward data: $e");
      return null;
    }
  }
}
