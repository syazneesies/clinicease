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
      body: isLoading ? const Center(child: CircularProgressIndicator()) : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Reward Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      leading: Icon(Icons.badge, size: 32, color: Colors.purple.shade900),
                      title: Text(reward?.rewardName?? 'Reward Name'),
                      subtitle: const Text('Reward Name'),
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    ListTile(
                      leading: Icon(Icons.calendar_today, size: 32, color: Colors.purple.shade900),
                      title: Text(reward != null ? DateFormat('dd-MM-yyyy').format(reward!.rewardDate!) : 'Redeemed By'),
                      subtitle: const Text('Redeemed By'),
                      contentPadding: const EdgeInsets.all(0),
                    ),
                  ],
                ),
              ),          
            ]
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
            DateTime selectedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss.S').parse('${reward!.rewardDate} ${timeController.text}');
            // Prepare booking data
            Map<String, dynamic> purchaseRewardData = {
              'rewardName': reward!.rewardName,
              'rewardDate': Timestamp.fromDate(reward!.rewardDate!),
              'rewardDescription': reward!.rewardDescription,
              'userId': user!.id, 
              'serviceId': reward!.rewardId, 
              'createdAt': FieldValue.serverTimestamp(), 
            };

            // Print booking data to console
            print('Purchase Reward Data: $purchaseRewardData');
            
            try {
              // Update service quantity
              await RewardService().updateRewardQuantity(reward!.rewardId!);

              // Call ServiceService to save booking details
              await RewardService().savePurchaseRewardDetails(purchaseRewardData);

              // Show success message or handle success as needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reward purchase successfully')),
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
          } else {
            // Handle null values
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Error: Some data is null')),
            );
          }
        },
          child: const Text('Purchase'),
        ),

        ),
      )    
    );
  }
}