import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:voting_app/components/my_textfield.dart';
import 'package:voting_app/admin/admin_nav.dart';
import 'package:voting_app/dialogs.dart';

class OfficerReg extends StatefulWidget {
  const OfficerReg({Key? key}) : super(key: key);

  @override
  _OfficerRegState createState() => _OfficerRegState();
}

class _OfficerRegState extends State<OfficerReg> {
  //controllers for form fields
  final TextEditingController officerIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  //currently selected navigation bar index
  int _selectedIndex = 0;
  //handling navbar ontap
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
              //ID input field
              MyTextfield(
                hintText: 'Officer ID',
                controller: officerIdController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              //Name
              MyTextfield(
                hintText: 'Name',
                controller: nameController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              //email
              MyTextfield(
                hintText: 'Email',
                controller: emailController,
                obscureText: false,
              ),
              const SizedBox(height: 20),
              //password
              MyTextfield(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true),
              const SizedBox(height: 20),
              //confirm password
              MyTextfield(
                  hintText: 'Confirm Password',
                  controller: confirmPassController,
                  obscureText: true),
              const SizedBox(height: 20),
              //country
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
                      if (passwordController.text != confirmPassController.text) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Password Mismatch",
                          message: "Password and Confirm Password do not match.",
                        );
                        return;
                      }

                      createOfficerAccount(
                        context,
                        emailController.text,
                        passwordController.text,
                        nameController.text,
                        countryController.text,
                        officerIdController.text,
                        () {
                          // Clear all controllers
                          setState(() {
                            officerIdController.clear();
                            nameController.clear();
                            emailController.clear();
                            passwordController.clear();
                            confirmPassController.clear();
                            countryController.clear();
                          });
                        },
                      );
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
        onTap: (index) {
          _onNavItemTapped(index);
        },
      ),
    );
  }
}


Future<void> createOfficerAccount(
  BuildContext context,
  String email,
  String password,
  String name,
  String country,
  String id,
  VoidCallback onSuccessClearFields,
) async {
  try {
    User? adminUser = FirebaseAuth.instance.currentUser;

    if (adminUser == null) {
      throw Exception("Admin not logged in.");
    }

    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(adminUser.uid)
        .get();

    if (!adminDoc.exists || adminDoc['role'] != 'Admin') {
      throw Exception("Only admins can create officers.");
    }

    UserCredential userCredential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .set({
      'email': email,
      'role': 'Officer',
      'id': id,
      'uid': userCredential.user!.uid,
      'name': name,
      'country': country,
      'status': 'Active',
    });

    CustomDialog.showDialogBox(context,
        title: "Success", message: "Officer account created successfully.");

    // Clear text fields
    onSuccessClearFields();
  } catch (e) {
    CustomDialog.showDialogBox(context,
        title: "Error", message: "Failed to create officer account: $e");
  }
}


//bonjure