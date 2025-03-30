import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'textfield_wid.dart';
import 'navigation_bar.dart';

class OfficerReg extends StatefulWidget {
  const OfficerReg({Key? key}) : super(key: key);

  @override
  _OfficerRegState createState() => _OfficerRegState();
}

class _OfficerRegState extends State<OfficerReg> {
  final TextEditingController officerIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController =TextEditingController();
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
              textfield_wid(label: 'Officer ID', controller: officerIdController),
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
                      createOfficerAccount(emailController.text, passwordController.text, nameController.text, countryController.text, officerIdController.text);
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

Future<void> createOfficerAccount(String email, String password, String name, String country, String id) async {
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
          'name': name,
          'country': country, // Assign officer role
        }
    );

    print("Officer account created successfully.");
    
    //Pop up: Successful code here
    // 
  } catch (e) {
    print("Error creating officer account: $e");

    // Pop up: Unsuccesfful code here
  }
}
