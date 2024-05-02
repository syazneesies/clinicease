import 'package:clinicease/models/purchased_reward_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:clinicease/models/reward_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
        reward.rewardId = doc.id;
        rewards.add(reward);
      }
    } catch (e) {
      print("Error getting rewards: $e");
    }

    return rewards;
  }

// Retrieve reward data from Firestore
  Future<RewardModel?> getRewardData(String rewardUID) async {
    try {
      DocumentSnapshot documentSnapshot =
          await _firestore.collection('rewards').doc(rewardUID).get();

      if (documentSnapshot.exists) {
        // Service data found, parse it into UserModel
        Map<String, dynamic> rewardData = documentSnapshot.data() as Map<String, dynamic>;
        RewardModel reward = RewardModel.fromJson(rewardData);
        reward.rewardId = documentSnapshot.id;
        return reward;
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
    // Save booking details to Firestore
  Future<void> savePurchaseRewardDetails(Map<String, dynamic> purchaseRewardData) async {
    try {
      // Add the booking details to the 'booked_services' collection
      await _firestore.collection('purchased_rewards').add(purchaseRewardData);

      // Show success message or handle success as needed
      print('Purchased rewards successfully');
    } catch (error) {
      // Show error message or handle error as needed
      print('Failed to save purchased reward: $error');
    }
  }

    Future<void> updateRewardQuantity(String rewardId) async {
    try {
      await rewardCollection.doc(rewardId).update({
        'rewardQuantity': FieldValue.increment(-1),
      });
    } catch (e) {
      print("Error updating reward quantity: $e");
      throw e;
    }
  }
}

class BookedServiceService {
  final CollectionReference _bookedServiceCollection =
      FirebaseFirestore.instance.collection('purchased_rewards');

  Future<List<PurchasedRewardModel>> getPurchasedReward() async {
    List<PurchasedRewardModel> purchasedRewards = [];

    try {
      QuerySnapshot querySnapshot = await _bookedServiceCollection.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PurchasedRewardModel purchasedReward =
            PurchasedRewardModel.fromJson(data);
        purchasedReward.purchased_rewardId = doc.id;
        purchasedRewards.add(purchasedReward);
      }
    } catch (e) {
      print("Error getting booked services: $e");
    }

    return purchasedRewards;
  }
}

class PurchasedRewardService {
  final CollectionReference _purchasedRewardsCollection =
      FirebaseFirestore.instance.collection('purchased_rewards');

  // Current user ID
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  Future<List<PurchasedRewardModel>> getPurchasedRewards() async {
    List<PurchasedRewardModel> purchasedRewards = [];

    try {
      QuerySnapshot querySnapshot = await _purchasedRewardsCollection
          .where('userId', isEqualTo: userId) 
          .get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        PurchasedRewardModel purchasedReward =
            PurchasedRewardModel.fromJson(data);
        purchasedReward.purchased_rewardId = doc.id;
        purchasedRewards.add(purchasedReward);
      }
    } catch (e) {
      print("Error getting purchased Rewards: $e");
    }

    return purchasedRewards;
  }
}


