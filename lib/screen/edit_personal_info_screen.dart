// Create me a stateful widget called EditPersonalInfoScreen

import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  const EditPersonalInfoScreen({super.key});

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final AuthService _authService = AuthService();
  final GetStorage _box = GetStorage();
  String? userId;

  @override
  void initState() {
    super.initState();
    userId = _box.read('uid');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Personal Info'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _authService.getUserData(userId!),
        builder: (context, snapshot) {
          snapshot.hasData ? print(snapshot.data) : print('No data');
          snapshot.hasError ? print(snapshot.error) : print('No error');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final user = snapshot.data!;
            return EditProfileDataScreen(user: user);
          } else {
            return const Center(child: Text('No user data found'));
          }
        },
      ),
    );
  }
}

class EditProfileDataScreen extends StatefulWidget {
  const EditProfileDataScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<EditProfileDataScreen> createState() => _EditProfileDataScreenState();
}

class _EditProfileDataScreenState extends State<EditProfileDataScreen> {
  final AuthService _authService = AuthService();
  final GetStorage _box = GetStorage();
  String? userId;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController identificationNumberController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController genderController = TextEditingController();

  @override
  void initState() {
    print(widget.user.toJson());
    fullNameController.text = widget.user.fullName!;
    identificationNumberController.text = widget.user.identificationNumber!;
    phoneNumberController.text = widget.user.phoneNumber!;
    emailController.text = widget.user.email!;
    birthdateController.text = widget.user.birthdate.toString();
    genderController.text = widget.user.gender!;
    userId = _box.read('uid');

    if (!mounted) {
      return;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Title
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Personal Info',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
      
              const SizedBox(height: 20),
              TextFormField(
                controller: fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: identificationNumberController,
                decoration: const InputDecoration(
                  labelText: 'Identification Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
          
              // Calendar picker for user.birthdate
              TextFormField(
                controller: birthdateController,
                decoration: const InputDecoration(
                  labelText: 'Birthdate',
                  border: OutlineInputBorder(),
                ),
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: widget.user.birthdate ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                },
                readOnly: true,
              ),
              const SizedBox(height: 10),
      
              // Create gender dropdown
              DropdownButtonFormField<String>(
                value: widget.user.gender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'Male',
                    child: Text('Male'),
                  ),
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text('Female'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    genderController.text = value!;
                  });
                },
              )
            ]
          ),
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () async {
              final updatedUser = UserModel(
                id: userId,
                fullName: fullNameController.text,
                identificationNumber: identificationNumberController.text,
                phoneNumber: phoneNumberController.text,
                email: emailController.text,
                birthdate: DateTime.parse(birthdateController.text), 
                gender: genderController.text,
              );
              bool isSuccess = await _authService.updateUserData(updatedUser);

              if (isSuccess) {
                Navigator.of(context).pop({true});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User data updated successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Failed to update user data')),
                );
              }
              
            }, child: const Text('Save'),
          ),
        ),
      )    
    );
  }
}