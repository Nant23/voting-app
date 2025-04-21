import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user.dart' as u;
import 'components/my_textfield.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showProgress = false;
  final _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  var options = ['User', 'Admin'];
  var role = "User"; // Ensuring role defaults to 'User'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Get started text
              const Text(
                'Let\'s Get Started!',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),

              const SizedBox(height: 20),

              MyTextfield(
                  controller: usernameController,
                  hintText: 'Username',
                  obscureText: false),
              const SizedBox(height: 10),

              MyTextfield(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true),
              const SizedBox(height: 10),

              MyTextfield(
                  controller: confirmpassController,
                  hintText: 'Confirm password',
                  obscureText: true),
              const SizedBox(height: 10),

              MyTextfield(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false),
              const SizedBox(height: 10),

              MyTextfield(
                  controller: countryController,
                  hintText: 'Country',
                  obscureText: false),
              const SizedBox(height: 20),

              //Sign up button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    signUp(usernameController.text, emailController.text,
                        passwordController.text, countryController.text, role);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF46639B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 55,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  // User sign up function
  void signUp(String username, String email, String password, String country,
      String role) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      postDetailsToFirestore(
          userCredential.user, username, email, country, role);
    } catch (e) {
      setState(() => showProgress = false);
    }
  }

  // This function stores the users details to firestore database
  void postDetailsToFirestore(User? user, String username, String email,
      String country, String role) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userName': username,
        'email': email,
        'country': country,
        'role': role,
        'status': 'Active'
      }, SetOptions(merge: true));
      setState(() => showProgress = false);
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => u.User()));
    }
  }
}
