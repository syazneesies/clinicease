import 'package:clinicease/models/purchased_reward_model.dart';
import 'package:clinicease/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:clinicease/screen/reward_receipt_screen.dart'; 

class MyRewardDetailScreen extends StatefulWidget {
  final String purchased_rewardId;

  const MyRewardDetailScreen({Key? key, required this.purchased_rewardId}) : super(key: key);

  @override
  _MyRewardDetailScreenState createState() => _MyRewardDetailScreenState();
}

class _MyRewardDetailScreenState extends State<MyRewardDetailScreen> {
  final PurchasedRewardService _purchasedRewardService = PurchasedRewardService();
  late Future<PurchasedRewardModel?> _rewardFuture;

  @override
  void initState() {
    super.initState();
    _loadRewardDetails();
  }

  void _loadRewardDetails() {
    _rewardFuture = _purchasedRewardService.getRewardDetails(widget.purchased_rewardId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Detail'),
      ),
      body: FutureBuilder<PurchasedRewardModel?>(
        future: _rewardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final reward = snapshot.data!;
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Reward Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Reward Name: ${reward.rewardName ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${reward.rewardDescription ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Valid Until: ${reward.rewardDate != null ? DateFormat('dd-MM-yyyy').format(reward.rewardDate!) : 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Purchased On: ${reward.createdAt != null ? DateFormat('dd-MM-yyyy').format(reward.createdAt!) : 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Reward Status: ${reward.rewardStatus ?? 'N/A'}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: reward.rewardStatus == 'Redeemed' ? Colors.green : Colors.red,
                    ),
                  ),
                  if (reward.rewardStatus != 'Redeemed')
                    SizedBox(height: 20),
                  if (reward.rewardStatus != 'Redeemed')
                    Center(
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => RewardReceiptScreen(
                                rewardId: widget.purchased_rewardId,
                              ),
                            ),
                          );

                          if (result == true) {
                            // Refresh the page if the reward status was updated
                            _loadRewardDetails();
                            setState(() {});
                          }
                        },
                        child: Text('Use Reward Now'),
                      ),
                    ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Reward not found.'));
          }
        },
      ),
    );
  }
}
