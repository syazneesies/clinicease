import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/reward_model.dart';

class RewardService {
  final CollectionReference rewardCollection =
      FirebaseFirestore.instance.collection('rewards');

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
}
