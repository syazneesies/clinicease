import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:clinicease/models/user_model.dart';


class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Register with email and password
  Future<User?> registerWithEmailAndPassword(UserModel user) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );
      User? firebaseUser = result.user;
      return firebaseUser;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Store user data in Firestore
  Future<void> storeUserData(UserModel user) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.id).set({
        'fullName': user.fullName,
        'identificationNumber': user.identificationNumber,
        'phoneNumber': user.phoneNumber,
        'email': user.email,
        'birthdate': user.birthdate,
        'gender': user.gender,
        
      });
    } catch (error) {
      print('Error storing user data: $error');
      throw error;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
