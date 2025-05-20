import 'package:flutter/material.dart';
import 'package:voting_app/components/my_textfield.dart';
//import 'package:voting_app/forgot_password/fp_otp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FpEmail extends StatefulWidget {
  const FpEmail({super.key});

  @override
  State<FpEmail> createState() => _FpEmailState();
}

class _FpEmailState extends State<FpEmail> {
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 25),

                // Image
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Container(
                    height: 390,
                    width: 390,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://res.cloudinary.com/dmtsrrnid/image/upload/v1742726238/voting_image_pqwrks.jpg",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // Email Textfield
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 30),

                // Next Button
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      String enteredEmail = emailController.text.trim().toLowerCase();

                      if (enteredEmail.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter an email.")),
                        );
                        return;
                      }

                      try {
                        QuerySnapshot userQuery = await FirebaseFirestore.instance
                            .collection('users')
                            .where('email', isEqualTo: enteredEmail)
                            .get();

                        if (userQuery.docs.isNotEmpty) {
                          // ✅ Send password reset email using Firebase Auth
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email: enteredEmail);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Password reset email sent.")),
                            );

                            // Optionally navigate back or to login screen
                            Navigator.pop(context);
                          } on FirebaseAuthException catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${e.message}")),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Email not found in our records.")),
                          );
                        }
                      } catch (e) {
                        debugPrint("Firestore error: $e");
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("An error occurred. Please try again.")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46639B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 38,
                        vertical: 11,
                      ),
                    ),
                    child: const Text(
                      "Next",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
