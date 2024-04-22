import 'package:clinicease/models/user_model.dart';
import 'package:clinicease/screen/forgot_password_screen.dart';
import 'package:clinicease/screen/home_screen.dart';
import 'package:clinicease/screen/sign_up_screen.dart';
import 'package:clinicease/services/auth_service.dart';
import 'package:clinicease/services/storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Import statements remain the same
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthService _auth = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // Debugging
    if (kDebugMode) {
      _emailController.text = 'tester11@gmail.com';
      _passwordController.text = 'tester123';
    }
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(_emailController != null, 'Email must not be null');
    assert(_passwordController != null, 'Password must not be null');
    return Scaffold(
      appBar: AppBar(
        title: const Text("ClinicEase Login", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF202050), 
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset("assets/loginbanner.jpg", height: 200),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController, // Link controller
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController, // Link controller
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
                const SizedBox(height: 20),
                
                
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Sign in process
                      User? user = await _auth.signInWithEmailAndPassword(
                        _emailController.text.trim(),
                        _passwordController.text.trim(),
                      );

                      if (user != null) {
                        // Get user ID
                        User? user = FirebaseAuth.instance.currentUser;
                        StorageService.setUID(user!.uid);

                        // Get user data
                        await _auth.getUserData(user.uid).then((value) {
                          if (value != null) {
                            StorageService.setUserData(value);
                          }
                        });

                        // Check if userData is successfully stored
                        UserModel? userData = StorageService.getUserData();
                        if (userData == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('An error occurred. Please re-login and try again.'),
                            ),
                          );
                          return;
                        }

                        // If userData is not null, navigate to home screen
                        // Navigate to home screen after successful login
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );

                      } else {
                        // Show error message
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid email or password')),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF202050), 
                  ),
                  child: const Text("Login", style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 10),
                
                // Register button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) => const RegisterScreen()),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}