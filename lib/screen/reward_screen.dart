import 'package:clinicease/screen/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/reward_model.dart';
import 'package:clinicease/services/reward_service.dart';
//import 'package:clinicease/screens/service_detail_screen.dart';

class RewardScreen extends StatefulWidget {
  @override
  _RewardScreenState createState() => _RewardScreenState();
}

class _RewardScreenState extends State<RewardScreen> {
  final RewardService _rewardService= RewardService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rewards List'),
      ),
      body: FutureBuilder(
        future: _rewardService.getRewards(),
        builder: (context, AsyncSnapshot<List<Reward>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
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
                return ListTile(
                  leading: Image.network(
                    reward.imageUrl,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(reward.rewardName),
                  subtitle: Text(
                    'Date: ${reward.rewardDate.toString()} Point: ${reward.rewardPoint.toString()}',
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => MyProfileScreen(),
                        //serviceId: service.id
                      ));
                    },
                    child: Text('Redeem Now'),
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
