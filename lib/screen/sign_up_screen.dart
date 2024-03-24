import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clinicease/services/auth_services.dart';
import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/screen/login_screen.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextStyle _textStyle = TextStyle(
    fontFamily: 'PoppinsRegular',
  );

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _identificationController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  DateTime _selectedBirthdate = DateTime.now();
  String? _selectedGender;

  AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fullNameController,
              style: _textStyle,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _identificationController,
              style: _textStyle,
              decoration: InputDecoration(
                labelText: "Identification Number",
                prefixIcon: Icon(Icons.credit_card, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _phoneNumberController,
              style: _textStyle,
              decoration: InputDecoration(
                labelText: "Phone Number (+60)",
                prefixIcon: Icon(Icons.phone, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              style: _textStyle,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              style: _textStyle,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 10),
            
            InkWell(
              onTap: () {
                _selectDate(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: "Birthday",
                  prefixIcon: Icon(Icons.calendar_today, color: Colors.grey),
                  border: OutlineInputBorder(),
                ),
                child: Text(
                  "${_selectedBirthdate.toLocal()}".split(' ')[0],
                  style: _textStyle,
                ),
              ),
            ),

            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: "Gender",
                prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                border: OutlineInputBorder(),
              ),
              items: [
                null, // Placeholder item
                "Male",
                "Female",
              ]
                  .map((gender) => DropdownMenuItem<String>(
                        value: gender,
                        child: Text(
                          gender ?? "Please select a gender",
                          style: _textStyle,
                        ),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),

            SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async {
    // Call registration logic here
    var userModel = UserModel(
      id: '', // We will set this after obtaining the UID from Firebase
      fullName: _fullNameController.text,
      identificationNumber: _identificationController.text,
      phoneNumber: _phoneNumberController.text,
      email: _emailController.text,
      password: _passwordController.text,
      birthdate: _selectedBirthdate,
      gender: _selectedGender ?? '',
    );

    // Register the user and get the UID from AuthService
    String? userId = await _authService.registerWithEmailAndPassword(userModel);
    if (userId != null) {
      // Set the obtained UID to userModel
      userModel = userModel.copyWith(id: userId);

      // Registration successful, store user data in Firestore
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'fullName': userModel.fullName,
          'identificationNumber': userModel.identificationNumber,
          'phoneNumber': userModel.phoneNumber,
          'email': userModel.email,
          'birthdate': userModel.birthdate,
          'gender': userModel.gender,
        });
        // Navigate to the login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
        );
      } catch (e) {
        print('Error storing user data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error storing user data. Please try again.'),
            duration: Duration(seconds: 3),
                    ),
                  );
                }
              } else {
                // Registration failed, handle error accordingly
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Registration failed. Please try again.'),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(textStyle: _textStyle),
            child: Text("Register"),
          ),

            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                );
              },
              child: Text(
                "Return to Login",
                style: _textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthdate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedBirthdate)
      setState(() {
        _selectedBirthdate = picked;
      });
  }
}
