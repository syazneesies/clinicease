import 'package:clinicease/screen/reward_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/reward_model.dart';
import 'package:clinicease/services/reward_service.dart';
import 'package:intl/intl.dart';

class RewardScreen extends StatefulWidget {
  const RewardScreen({super.key});

  @override
  State<RewardScreen> createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final RewardService _rewardService = RewardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rewards List'),
      ),
      body: FutureBuilder(
        future: _rewardService.getRewards(),
        builder: (context, AsyncSnapshot<List<RewardModel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final reward = snapshot.data![index];
                return RewardCardWidget(reward: reward);
              },
            );
          }
        },
      ),
    );
  }
}


class RewardCardWidget extends StatelessWidget {
  const RewardCardWidget({super.key, required this.reward});

  final RewardModel reward;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 170,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            spreadRadius: 4,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ]
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // border: Border.all(color: Colors.grey.shade200),
              ),
              child: Image.network(
                reward.imageUrl!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Reward name
                  FittedBox(
                    fit: BoxFit.cover,
                    child: Text(
                      reward.rewardName!,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('${reward.rewardPoint.toString()} Points',),
                 Text('Date: ${reward.rewardDate != null ? DateFormat('dd-MM-yyyy').format(reward.rewardDate!) : 'N/A'}'),
                  const SizedBox(height: 16),

                  // Button
                  Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => RewardDetailScreen(rewardId: reward.rewardId!),
                        ));
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   SnackBar(
                        //     content: Text('Redeem button clicked - ${reward.rewardName}'),
                        //   ),
                        // );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(80),
                        ),
                        child: const Text('Redeem', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return ListTile(
  //     leading: Image.network(
  //       reward.imageUrl!,
  //       width: 50,
  //       height: 50,
  //     ),
  //     title: Text(reward.rewardName!),
  //     subtitle: Text(
  //       'Date: ${reward.rewardDate.toString()} Point: ${reward.rewardPoint.toString()}',
  //     ),
  //     trailing: ElevatedButton(
  //       onPressed: () {
  //         Navigator.of(context).push(MaterialPageRoute(
  //           builder: (context) => const MyProfileScreen(),
  //           //serviceId: service.id
  //         ));
  //       },
  //       child: const Text('Redeem Now'),
  //     ),
  //   );
  // }
}