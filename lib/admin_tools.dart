import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminTools {
  Future<void> createOfficerAccount(String email, String password) async {
  try {
    // Get current user
    User? adminUser = FirebaseAuth.instance.currentUser;

    // Check if admin is logged in
    if (adminUser == null) {
      throw Exception("Admin not logged in.");
    }

    // Get admin's role from Firestore
    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(adminUser.uid)
        .get();

    if (!adminDoc.exists || adminDoc['role'] != 'Admin') {
      throw Exception("Only admins can create officers.");
    }

    // Create user in Firebase Authentication
    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Store user info in Firestore
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'email': email,
      'role': 'Officer', // Assign officer role
    });

    print("Officer account created successfully.");
  } catch (e) {
    print("Error creating officer account: $e");
  }
}
}