import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'textfield_wid.dart';
import 'navigation_bar.dart';
import 'dialogs.dart';

class OfficerReg extends StatefulWidget {
  const OfficerReg({Key? key}) : super(key: key);

  @override
  _OfficerRegState createState() => _OfficerRegState();
}

class _OfficerRegState extends State<OfficerReg> {
  final TextEditingController officerIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(title: Text('Officer Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              textfield_wid(
                  label: 'Officer ID', controller: officerIdController),
              textfield_wid(label: 'Name', controller: nameController),
              textfield_wid(label: 'Email', controller: emailController),
              textfield_wid(
                  label: 'Password',
                  controller: passwordController,
                  obscureText: true),
              textfield_wid(
                  label: 'Confirm Password',
                  controller: confirmPassController,
                  obscureText: true),
              textfield_wid(label: 'Country', controller: countryController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      createOfficerAccount(
                          context,
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          countryController.text,
                          officerIdController.text);
                    },
                    child: Text('Add'),
                  ),
                  OutlinedButton(
                    onPressed: () {},
                    child: Text('Remove'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}

Future<void> createOfficerAccount(BuildContext context, String email,
    String password, String name, String country, String id) async {
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
      'role': 'Officer',
      'id': id,
      'uid': userCredential.user!.uid,
      'name': name,
      'country': country, // Assign officer role
    });

    print("Officer account created successfully.");

    //Pop up: Successful code here
    CustomDialog.showDialogBox(context,
        title: "Success", message: "Officer account created successfully.");
  } catch (e) {
    print("Error creating officer account: $e");

    // Pop up: Unsuccesfful code here
    CustomDialog.showDialogBox(context,
        title: "Error", message: "Failed to create officer account: $e");
  }
}

Future<void> deleteOfficerAccount(String officerEmail) async {
  try {
    // Get current admin user
    User? adminUser = FirebaseAuth.instance.currentUser;

    if (adminUser == null) {
      throw Exception("Admin not logged in.");
    }

    // Get admin's role from Firestore
    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(adminUser.uid)
        .get();

    if (!adminDoc.exists || adminDoc['role'] != 'Admin') {
      throw Exception("Only admins can delete officers.");
    }

    // Find the officer's user document in Firestore
    QuerySnapshot officerQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: officerEmail)
        .where('role', isEqualTo: 'Officer') // Ensure it's an officer
        .get();

    if (officerQuery.docs.isEmpty) {
      throw Exception("Officer account not found.");
    }

    // Get the officer's UID
    String officerUid = officerQuery.docs.first.id;

    // Delete Firestore document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(officerUid)
        .delete();

    // Delete from Firebase Authentication
    await FirebaseAuth.instance
        .fetchSignInMethodsForEmail(officerEmail)
        .then((signInMethods) async {
      if (signInMethods.isNotEmpty) {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: officerEmail,
                password:
                    "temporary-password"); // Require the password to delete
        await userCredential.user?.delete();
      }
    });

    print("Officer account deleted successfully.");
  } catch (e) {
    print("Error deleting officer account: $e");
  }
}
