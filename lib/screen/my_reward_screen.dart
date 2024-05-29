import 'package:clinicease/screen/my_reward_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/purchased_reward_model.dart';
import 'package:clinicease/services/reward_service.dart';
import 'package:intl/intl.dart';
import 'package:clinicease/services/storage_service.dart';

class MyRewardScreen extends StatefulWidget {
  const MyRewardScreen({Key? key}) : super(key: key);

  @override
  State<MyRewardScreen> createState() => _MyRewardScreenState();
}

class _MyRewardScreenState extends State<MyRewardScreen> {
  final PurchasedRewardService _purchasedRewardService = PurchasedRewardService();
  late Future<List<PurchasedRewardModel>> _rewardsFuture;
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = StorageService.getUID();
    if (userId != null) {
      _loadRewards();
    }
  }

  void _loadRewards() {
    setState(() {
      _rewardsFuture = _purchasedRewardService.getPurchasedRewards(userId!);
    });
  }

  Future<void> _refreshRewards() async {
    _loadRewards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rewards'),
      ),
      body: userId == null
          ? Center(child: Text('User not logged in'))
          : RefreshIndicator(
              onRefresh: _refreshRewards,
              child: FutureBuilder<List<PurchasedRewardModel>>(
                future: _rewardsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No Purchased reward yet'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final purchasedReward = snapshot.data![index];
                        return Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Status: ${purchasedReward.rewardStatus ?? 'N/A'}',
                                  style: TextStyle(
                                    color: purchasedReward.rewardStatus == 'Redeemed' ? Colors.green : Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ListTile(
                                  title: Text(purchasedReward.rewardName ?? 'N/A'),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Valid until: ${purchasedReward.rewardDate != null ? DateFormat('dd-MM-yyyy').format(purchasedReward.rewardDate!) : 'N/A'}'),
                                      Text('Purchased on: ${purchasedReward.createdAt != null ? DateFormat('dd-MM-yyyy').format(purchasedReward.createdAt!) : 'N/A'}'),
                                    ],
                                  ),
                                  trailing: ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => MyRewardDetailScreen(purchased_rewardId: purchasedReward.purchased_rewardId!),
                                        ),
                                      );
                                    },
                                    child: Text('View Details'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
    );
  }
}
