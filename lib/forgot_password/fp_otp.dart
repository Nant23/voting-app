import 'package:flutter/material.dart';
import 'new_pass.dart';
// import 'dart:math';

class FpOtp extends StatefulWidget {
  const FpOtp({super.key});

  @override
  State<FpOtp> createState() => _FpOtpState();
}

class _FpOtpState extends State<FpOtp> {
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

                // OTP fields
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(4, (index) {
                    return SizedBox(
                      width: 50,
                      child: TextField(
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 20),
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        decoration: InputDecoration(
                          counterText: "",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),

                // Resend OTP button
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // String otp = generateOTP();
                      // CustomDialog.showDialogBox(
                      //   context,
                      //   message: otp,
                      //   title: "Your 4 digit code",
                      // );
                    },
                    child: const Text(
                      "Resend OTP",
                      style: TextStyle(color: Color(0xFFAF6666), fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Next button
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewPass(),
                        ),
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
                      "next",
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
