import 'package:flutter/material.dart';
import 'package:voting_app/components/my_textfield.dart';
import 'package:voting_app/forgot_password/fp_otp.dart';
// import 'dart:math';

class FpEmail extends StatefulWidget {
  const FpEmail({super.key});

  @override
  State<FpEmail> createState() => _FpEmailState();
}

class _FpEmailState extends State<FpEmail> {
  final TextEditingController emailController = TextEditingController();

  // // Generate OTP
  // String generateOTP() {
  //   Random random = Random();
  //   int otp = random.nextInt(9000) + 1000;
  //   return otp.toString();
  // }

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

                //email
                MyTextfield(
                  controller: emailController,
                  hintText: "Email",
                  obscureText: false,
                ),
                const SizedBox(height: 30),

                // OTP button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const FpOtp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46639B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 38,
                        vertical: 11,
                      ),
                    ),
                    child: const Text(
                      "Send OTP",
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
