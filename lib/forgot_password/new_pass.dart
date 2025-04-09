import 'package:flutter/material.dart';
import 'package:voting_app/admin/admin_dash.dart';
import 'package:voting_app/components/my_textfield.dart';
import 'package:voting_app/login.dart';

class NewPass extends StatefulWidget {
  const NewPass({super.key});

  @override
  State<NewPass> createState() => _NewPassState();
}

class _NewPassState extends State<NewPass> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController conpasswordController = TextEditingController();

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

                //Password
                MyTextfield(
                  hintText: 'Password',
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                //Confirm Password
                MyTextfield(
                  hintText: 'Confirm Password',
                  controller: conpasswordController,
                  obscureText: true,
                ),
                const SizedBox(height: 30),

                //login
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF46639B)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 15,
                      ),
                      child: Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white),
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
