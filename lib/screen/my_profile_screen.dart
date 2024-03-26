import 'package:clinicease/screen/login_screen.dart';
import 'package:clinicease/screen/personal_info_screen.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:flutter/material.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  String? userUID;

  @override
  void initState() {
    userUID = StorageService.getUID();
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
                // Handle My Rewards onTap
              },
              title: const Text(
                'User UID',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                userUID ?? 'No User ID',
              ),
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
              title: const Text(
                'Personal Information',
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
                // Clear user ID from storage
                StorageService.clearAll();

                // Navigate to login screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              title: const Text(
                'Log Out',
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}