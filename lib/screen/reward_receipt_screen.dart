import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:clinicease/services/reward_service.dart';

class RewardReceiptScreen extends StatefulWidget {
  final String rewardId;

  const RewardReceiptScreen({Key? key, required this.rewardId}) : super(key: key);

  @override
  _RewardReceiptScreenState createState() => _RewardReceiptScreenState();
}

class _RewardReceiptScreenState extends State<RewardReceiptScreen> {
  final PurchasedRewardService _purchasedRewardService = PurchasedRewardService();

  @override
  void initState() {
    super.initState();
    _redeemReward();
  }

  Future<void> _redeemReward() async {
    await _purchasedRewardService.updateRewardStatus(widget.rewardId, 'Redeemed');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reward Receipt'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QR Code for Reward ID: ${widget.rewardId}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            QrImageView(
              data: widget.rewardId,
              version: QrVersions.auto,
              size: 200.0,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(true); 
              },
              child: Text('Done'),
            ),
          ],
        ),
      ),
    );
  }
}
