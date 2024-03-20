import 'package:clinicease/screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatelessWidget {
  TextStyle _textStyle = TextStyle(
    fontFamily: 'PoppinsRegular',
  );

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Forgot Your Password?",
              style: _textStyle.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Enter your registered email address to receive a password reset link.",
              style: _textStyle.copyWith(fontSize: 16),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              style: _textStyle,
              decoration: InputDecoration(
                labelText: "Email Address",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _resetPassword(context);
              },
              style: ElevatedButton.styleFrom(textStyle: _textStyle),
              child: Text("Send Reset Link"),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                );
              },
              style: TextButton.styleFrom(textStyle: _textStyle),
              child: Text("Return to Login"),
            ),
          ],
        ),
      ),
    );
  }

  void _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      // Show success message or navigate to a success screen
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password reset email sent successfully."),
      ));
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to send reset link. Please check your email and try again."),
      ));
    }
  }
}
