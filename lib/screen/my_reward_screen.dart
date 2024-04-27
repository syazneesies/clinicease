import 'package:clinicease/models/purchased_reward_model.dart';
import 'package:clinicease/services/reward_service.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/book_service_model.dart'; 
import 'package:clinicease/services/services_service.dart';
import 'package:intl/intl.dart'; 

class MyRewardScreen extends StatefulWidget {
  const MyRewardScreen({Key? key}) : super(key: key);

  @override
  State<MyRewardScreen> createState() => _MyRewardScreenState();
}

class _MyRewardScreenState extends State<MyRewardScreen> {
  final PurchasedRewardService _purchasedRewardService = PurchasedRewardService(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
      ),
      body: FutureBuilder(
        future: _purchasedRewardService.getPurchasedRewards(),
        builder: (context, AsyncSnapshot<List<PurchasedRewardModel>> snapshot) {
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
                final purchasedReward = snapshot.data![index];
                return ListTile(
                  // leading: Image.network(
                  //   bookedService.imageUrl!,
                  //   width: 50,
                  //   height: 50,
                  // ),
                  title: Text(purchasedReward.rewardName.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   Text('Valid until: ${purchasedReward.rewardDate != null ? DateFormat('dd-MM-yyyy').format(purchasedReward.rewardDate!) : 'N/A'}'),
                   Text('Purchased on: ${purchasedReward.createdAt != null ? DateFormat('dd-MM-yyyy').format(purchasedReward.createdAt!) : 'N/A'}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Handle button press action (if needed)
                    },
                    child: Text('View Details'),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
