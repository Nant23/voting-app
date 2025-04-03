import 'package:flutter/material.dart';
import 'components/my_textfield.dart';
import 'navigation_bar.dart';
import 'dialogs.dart';

class RemoveUser extends StatefulWidget {
  const RemoveUser({super.key});

  @override
  _RemoveUserState createState() => _RemoveUserState();
}

class _RemoveUserState extends State<RemoveUser> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final TextEditingController userIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(
        title: const Text('Remove User'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextfield(
                controller: userIdController,
                hintText: "User ID",
                obscureText: false,
              ),
              const SizedBox(height: 20),
              MyTextfield(
                controller: emailController,
                hintText: "Email",
                obscureText: false,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Add removal functionality
                  try {
                    CustomDialog.showDialogBox(context,
                        title: "Success", message: "Removed successsfully");
                  } catch (e) {
                    CustomDialog.showDialogBox(context,
                        title: "Error", message: "Failed to remove User");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF46639B),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Remove",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
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
