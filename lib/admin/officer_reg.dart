import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
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
      appBar: AppBar(
  title: Text('Officer Registration'),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Image.network(
        "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
        height: 60, // Adjust size as needed
        width: 60,
        fit: BoxFit.contain,
      ),
    ),
  ],
),
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
                      final id = officerIdController.text.trim();
                      final name = nameController.text.trim();
                      final email = emailController.text.trim();
                      final password = passwordController.text;
                      final confirmPass = confirmPassController.text;
                      final country = countryController.text.trim();

                      // Validation for empty fields
                      if (id.isEmpty ||
                          name.isEmpty ||
                          email.isEmpty ||
                          password.isEmpty ||
                          confirmPass.isEmpty ||
                          country.isEmpty) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Missing Fields",
                          message: "Please fill in all the fields.",
                        );
                        return;
                      }

                      //check password and confirm password
                      if (passwordController.text !=
                          confirmPassController.text) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Password Mismatch",
                          message:
                              "Password and Confirm Password do not match.",
                        );
                        return;
                      }

                      //if everything`s good then create officer
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

    //ensure only admins can register officers
    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(adminUser.uid)
        .get();

    if (!adminDoc.exists || adminDoc['role'] != 'Admin') {
      throw Exception("Only admins can create officers.");
    }

    //creating a secondary Firebase app to isolate officer registration
    FirebaseApp tempApp = await Firebase.initializeApp(
      name: 'tempApp',
      options: Firebase.app().options,
    );

    FirebaseAuth tempAuth = FirebaseAuth.instanceFor(app: tempApp);

    //create officer account with temp auth
    UserCredential userCredential = await tempAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    String officerUid = userCredential.user!.uid;

    //add officer data to Firestore
    await FirebaseFirestore.instance.collection('users').doc(officerUid).set({
      'email': email,
      'role': 'Officer',
      'id': id,
      'uid': officerUid,
      'name': name,
      'country': country,
      'status': 'Active',
      'createdAt': FieldValue.serverTimestamp(),
    });

    //clean up: delete the secondary app
    await tempApp.delete();

    //Show success message
    CustomDialog.showDialogBox(
      context,
      title: "Success",
      message: "Officer account created successfully.",
    );

    //Clear input fields
    onSuccessClearFields();
  } catch (e) {
    CustomDialog.showDialogBox(
      context,
      title: "Error",
      message: "Failed to create officer account: $e",
    );
  }
}
