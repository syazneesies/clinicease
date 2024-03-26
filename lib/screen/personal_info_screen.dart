import 'package:clinicease/screen/edit_personal_info_screen.dart';
import 'package:clinicease/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late Future<UserModel?> _userDataFuture;
  final AuthService _authService = AuthService();
  final GetStorage _box = GetStorage();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _box.read('uid');
    onRefresh();
  }

  onRefresh() {
    setState(() {
      _userDataFuture = _authService.getUserData(userId!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          snapshot.hasData ? print(snapshot.data) : print('No data');
          snapshot.hasError ? print(snapshot.error) : print('No error');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 80,
                  child: Icon(Icons.person, size: 80),
                ),
            
                const SizedBox(height: 24),
                Text(user.fullName!.toUpperCase(), style: Theme.of(context).textTheme.headlineLarge),
                Text(user.email!),
            
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Personal Information', style: Theme.of(context).textTheme.titleMedium),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const EditPersonalInfoScreen(),
                        ),
                      ).then((value) {
                        if (value != null) {
                          onRefresh();
                        }
                      }),
                      child: const Text('Edit'),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ListTile(
                        leading: Icon(Icons.badge, size: 32, color: Colors.purple.shade900),
                        title: const Text('Identification Number'),
                        subtitle: Text(user.identificationNumber!),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      ListTile(
                        leading: Icon(Icons.phone, size: 32, color: Colors.purple.shade900),
                        title: const Text('Phone Number'),
                        subtitle: Text(user.phoneNumber!),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      ListTile(
                        leading: Icon(Icons.cake, size: 32, color: Colors.purple.shade900),
                        title: const Text('Birthday'),
                        subtitle: Text('${user.birthdate!.day}-${user.birthdate!.month}-${user.birthdate!.year}'),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                      ListTile(
                        leading: Icon(Icons.person, size: 32, color: Colors.purple.shade900),
                        title: const Text('Gender'),
                        subtitle: Text(user.gender!),
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
          } else {
            return const Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}
