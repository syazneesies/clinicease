import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/reward_model.dart';

class RewardService {
  final CollectionReference rewardCollection =
      FirebaseFirestore.instance.collection('rewards');

  Future<List<Reward>> getRewards() async {
    List<Reward> rewards = [];

    try {
      QuerySnapshot querySnapshot = await rewardCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Reward reward = Reward.fromJson(data);
        rewards.add(reward);
      }
    } catch (e) {
      print("Error getting services: $e");
    }

    return rewards;
  }
}
