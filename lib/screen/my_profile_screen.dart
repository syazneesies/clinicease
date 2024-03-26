import 'package:clinicease/screen/personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  // Will delete later, dummy
  String? userUID;
  final TextStyle _textStyle = const TextStyle(
    fontFamily: 'PoppinsRegular',
  );
  final GetStorage box = GetStorage();

  @override
  void initState() {
    userUID = box.read('uid');
    setState(() {});
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'PoppinsRegular',
            color: Color(0xFF202050),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
              if (userUID != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                );
              } else {
                // Handle the case where userUID is null, perhaps by showing an error message
                print('User ID is null');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('An error occurred. Please re-login and try again.'),
                  ),
                );
              }
            },
              title: Text(
                'Personal Information',
                style: _textStyle,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                // Handle My Rewards onTap
              },
              title: Text(
                'User UID: $userUID',
                style: _textStyle,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
          const SizedBox(height: 20.0),
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: ListTile(
              onTap: () {
                // Handle Log Out onTap
              },
              title: Text(
                'Log Out',
                style: _textStyle,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}