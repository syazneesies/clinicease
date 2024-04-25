import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:clinicease/screen/reward_confirmation_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/reward_model.dart';
import 'package:clinicease/services/reward_service.dart';

class RewardDetailScreen extends StatefulWidget {
  const RewardDetailScreen({Key? key, required this.rewardId}) : super(key: key);
  final String rewardId;

  @override
  State<RewardDetailScreen> createState() => _RewardDetailScreenState();
}

class _RewardDetailScreenState extends State<RewardDetailScreen> {
  late Future<RewardModel?> _rewardDataFuture;
  final RewardService _rewardService = RewardService(); 

  @override
  void initState() {
    super.initState();

    onRefresh();
  }

  onRefresh() {
    setState(() {
      _rewardDataFuture = _rewardService.getRewardData(widget.rewardId); 
      print('Reward UID fetched #1: ${widget.rewardId}');
    });
 

    _rewardDataFuture.then((reward) {
      if (reward != null) {
        print('Reward UID fetched: ${reward.rewardId}');
        print('Reward UID fetched #2: ${reward.toJson()}');
      } else {
        print('Reward data not found');
      }
    });
  }


 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Reward Info'),
    ),
    body: FutureBuilder<RewardModel?>(
      future: _rewardDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final reward = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Image.network(
                    reward.imageUrl!,
                    width: 200,
                    height: 200,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    elevation: 4, // Add elevation for shadow effect
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10), // Rounded corners
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(reward.rewardName!.toUpperCase(), style: Theme.of(context).textTheme.headline6),
                          Text(reward.rewardDescription!),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Reward Information', style: Theme.of(context).textTheme.subtitle1),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Display service details here
                          // Replace this with your actual service details widget
                          // Below are placeholders, replace them with actual service details
                          Text('Reward Date: ${reward.rewardDate }'),
                          // Add more widgets to display other service details
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                        print('id: ${reward.rewardId!}');
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RewardConfirmationScreen(
                            rewardId: reward.rewardId!,
                          ),
                        ));
                      },
                    child: Text('Redeem Now'),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(child: Text('No reward data found'));
        }
      },
    ),
  );
}

}
