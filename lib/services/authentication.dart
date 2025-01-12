import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // Firestore instance for storing user data
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // FirebaseAuth instance for handling authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign up user function
  Future<String> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      // Ensure all fields are not empty
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Create the user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Store additional user information in Firestore
        await _firestore.collection('users').doc(userCredential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': userCredential.user!.uid,
        });

        res = "Success"; // User signed up successfully
      } else {
        res = "Please fill all the fields"; // Ensure all fields are filled
      }
    } catch (e) {
      res = e.toString(); // If any error occurs, return the error message
    }
    return res;
  }

  // Login user function
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      // Ensure fields are not empty
      if (email.isNotEmpty && password.isNotEmpty) {
        // Login user with email and password
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);

        res = "Success"; // Login successful
      } else {
        res = "Please enter all fields"; // Ensure all fields are filled
      }
    } catch (e) {
      res = e.toString(); // If any error occurs, return the error message
    }
    return res;
  }
}
