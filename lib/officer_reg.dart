import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:voting_app/components/my_textfield.dart';
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
              MyTextfield(
                hintText: 'Officer ID',
                controller: officerIdController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                hintText: 'Name',
                controller: nameController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                hintText: 'Email',
                controller: emailController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true),
              const SizedBox(height: 20),
              MyTextfield(
                  hintText: 'Confirm Password',
                  controller: confirmPassController,
                  obscureText: true),
              const SizedBox(height: 20),
              MyTextfield(
                hintText: 'Country',
                controller: countryController,
                obscureText: false,
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF46639B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 55,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () {
                      createOfficerAccount(
                          context,
                          emailController.text,
                          passwordController.text,
                          nameController.text,
                          countryController.text,
                          officerIdController.text);
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: Colors.white),
                    ),
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

