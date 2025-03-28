// import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'user.dart' as u;

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showProgress = false;
  bool _isObscure = true;
  bool _isObscure2 = true;

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpassController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController countryController = TextEditingController();


  var options = ['User', 'Admin'];
  //var _currentItemSelected = "User";
  var role = "User"; // Ensuring role defaults to 'User'

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[900],
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.orangeAccent[700],
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 80),
                      Text(
                        "Sign up Now",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      ),
                      SizedBox(height: 50),

                      //username testfield
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextField(
                                    controller: userNameController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Username',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      
                      SizedBox(height: 20),
                      _passwordField(passwordController, "Password", _isObscure, () {
                        setState(() => _isObscure = !_isObscure);
                      }),
                      SizedBox(height: 20),
                      _passwordField(confirmpassController, "Confirm Password", _isObscure2, () {
                        setState(() => _isObscure2 = !_isObscure2);
                      }),
                      SizedBox(height: 20),

                      // Email text field
                      TextFormField(
                        controller: emailController,
                        decoration: _inputDecoration("Email"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Email cannot be empty";
                          }
                          // if (!RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\.[a-z]+\$')
                          //     .hasMatch(value)) {
                          //   return "Please enter a valid email";
                          // }
                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),

                      
                      SizedBox(height: 20),


                      //Country text field
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                width: 160,
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  border: Border.all(color: Colors.white),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: TextField(
                                    controller: countryController,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Country',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),


                      //_roleDropdown(),
                      SizedBox(height: 20),
                      showProgress
                          ? CircularProgressIndicator()
                          : _button("SignUp", () {
                              setState(() => showProgress = true);
                              signUp(userNameController.text, emailController.text, passwordController.text, countryController.text, role);
                            }),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _passwordField(TextEditingController controller, String hintText, bool obscureText, VoidCallback toggleVisibility) {
    return TextFormField(
      obscureText: obscureText,
      controller: controller,
      decoration: _inputDecoration(hintText).copyWith(
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: toggleVisibility,
        ),
      ),
      validator: (value) {
        if (hintText == "Confirm Password" && value != passwordController.text) {
          return "Password did not match";
        }
        if (value == null || value.isEmpty || value.length < 6) {
          return "Password must be at least 6 characters long";
        }
        return null;
      },
    );
  }

  // Widget _roleDropdown() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Text(
  //         "Role:",
  //         style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
  //       ),
  //       SizedBox(width: 10),
  //       DropdownButton<String>(
  //         dropdownColor: Colors.blue[900],
  //         iconEnabledColor: Colors.white,
  //         items: options.map((String value) {
  //           return DropdownMenuItem<String>(
  //             value: value,
  //             child: Text(value, style: TextStyle(color: Colors.white, fontSize: 18)),
  //           );
  //         }).toList(),
  //         onChanged: (newValue) {
  //           setState(() {
  //             _currentItemSelected = newValue!;
  //             role = newValue;
  //           });
  //         },
  //         value: _currentItemSelected,
  //       ),
  //     ],
  //   );
  // }

  // Widget _actionButtons() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     children: [
  //       _button("Login", () {
  //         Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
  //       }),
  //       _button("SignUp", () {
  //         setState(() => showProgress = true);
  //         signUp(userNameController.text, emailController.text, passwordController.text, countryController.text, role);
  //       }),
  //     ],
  //   );
  // }

  Widget _button(String text, VoidCallback onPressed) {
    return MaterialButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5.0,
      height: 40,
      onPressed: onPressed,
      color: Colors.white,
      child: Text(text, style: TextStyle(fontSize: 20)),
    );
  }

  void signUp(String username, String email, String password, String country, String role) async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        postDetailsToFirestore(userCredential.user, username, email, country, role);
      } catch (e) {
        setState(() => showProgress = false);
      }
    }
  }

  void postDetailsToFirestore(User? user, String username, String email, String country, String role) async {
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({'userName': username, 'email': email, 'country': country, 'role': role}, SetOptions(merge: true));
      setState(() => showProgress = false);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => u.User()));
    }
  }
}
