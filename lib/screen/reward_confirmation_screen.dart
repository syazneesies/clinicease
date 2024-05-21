import 'package:clinicease/models/reward_model.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/services/reward_service.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RewardConfirmationScreen extends StatefulWidget {
  const RewardConfirmationScreen({super.key, required this.rewardId});
  final String rewardId;

  @override
  State<RewardConfirmationScreen> createState() => _RewardConfirmationScreenState();
}

class _RewardConfirmationScreenState extends State<RewardConfirmationScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  final RewardService _rewardService = RewardService();
  RewardModel? reward;

  late UserModel? user;
  late List<DateTime> timeOptions;
  bool isLoading = false;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = StorageService.getUID();
    user = StorageService.getUserData();
    getRewards();
  }

  getRewards() async {
  setState(() => isLoading = true);
  reward = await _rewardService.getRewardData(widget.rewardId);
  setState(() => isLoading = false);
}

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Purchase Reward'),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Reward Name before the image
                  Text(
                    reward?.rewardName ?? 'Reward Name',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Image displayed as square
                  reward?.imageUrl != null
                      ? Container(
                          width: double.infinity,
                          height: 200,
                          child: Image.network(
                            reward!.imageUrl!,
                            fit: BoxFit.fitHeight,
                          ),
                        )
                      : SizedBox(),

                  const SizedBox(height: 20),

                  // Purple box containing reward details
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Reward Description
                        Row(
                          children: [
                            Icon(Icons.notes, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Description:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          reward?.rewardDescription ?? 'Description',
                          style: TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 10),

                        // Redeemed By
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Redeemed By:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          reward != null
                              ? DateFormat('dd-MM-yyyy').format(reward!.rewardDate!)
                              : 'Redeemed By',
                          style: TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 10),

                        // Reward Points
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.grey),
                            const SizedBox(width: 5),
                            Text(
                              'Points Needed:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          reward?.rewardPoint.toString() ?? '0',
                          style: TextStyle(fontSize: 14),
                        ),

                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        extendBody: true,
        bottomNavigationBar: SizedBox(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
            onPressed: () async {
        if (reward != null && reward!.rewardDate != null && user != null) {
          // Check if user has sufficient reward points
          if ((user!.rewardPoints ?? 0) >= (reward!.rewardPoint ?? 0)) {
            // If user has sufficient points, show confirmation dialog
            bool confirmPurchase = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Confirm Purchase'),
                content: Text('Are you sure you want to purchase this reward?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Return false when user cancels
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Return true when user confirms
                    },
                    child: Text('Confirm'),
                  ),
                ],
              ),
            );

            // If user confirms the purchase
            if (confirmPurchase == true) {
            int newRewardPoints = (user?.rewardPoints ?? 0) - (reward?.rewardPoint ?? 0);

            try {
              // Update user's reward points in Firestore
              await FirebaseFirestore.instance.collection('users').doc(userId).update({
                'rewardPoints': newRewardPoints,
              });

              // Proceed with the purchase
              DateTime selectedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss.S').parse('${reward!.rewardDate} ${timeController.text}');
              // Prepare purchase data
              Map<String, dynamic> purchaseRewardData = {
                'rewardName': reward!.rewardName,
                'rewardDate': Timestamp.fromDate(reward!.rewardDate!),
                'rewardDescription': reward!.rewardDescription,
                'userId': userId, 
                'rewardId': reward!.rewardId, 
                'createdAt': FieldValue.serverTimestamp(),
                'rewardStatus' : "Unredemeed",
              };

              // Save purchase details and update reward quantity
              await RewardService().savePurchaseRewardDetails(purchaseRewardData);

              // Show success message or handle success as needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reward purchased successfully')),
              );

              // Pop the screen
              Navigator.of(context).pop();
            } catch (e) {
              // Handle error
              print("Error in purchasing reward: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error: Unable to proceed the transaction')),
              );
            }
          }
          } else {
            // If user doesn't have sufficient points, show error message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Insufficient reward points')),
            );
          }
        } else {
          // Handle null values
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error: Some data is null')),
          );
        }
      },
        
          child: Text('Purchase Reward'),
        ),

        ),
      )    
    );
  }
}