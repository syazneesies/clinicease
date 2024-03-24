import 'package:clinicease/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/user_model.dart';

class PersonalInfoScreen extends StatefulWidget {
  final String userId;

  const PersonalInfoScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _PersonalInfoScreenState createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late Future<UserModel?> _userDataFuture;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _userDataFuture = _authService.getUserData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Full Name: ${user.fullName}'),
                  Text('Identification Number: ${user.identificationNumber}'),
                  Text('Phone Number: ${user.phoneNumber}'),
                  Text('Email: ${user.email}'),
                  Text('Birthday: ${user.birthdate.toString()}'),
                  Text('Gender: ${user.gender}'),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to edit profile page
                    },
                    child: Text('Edit Profile'),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}
