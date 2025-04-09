import 'package:flutter/material.dart';
import 'package:voting_app/components/my_textfield.dart';
import 'package:voting_app/admin_nav.dart';
import 'package:voting_app/dialogs.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
                  deactivateOfficerAccount(
                      context, userIdController.text, emailController.text);
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
        onTap: (index) {
          _onNavItemTapped(index);
        },
      ),
    );
  }
}

Future<void> deactivateOfficerAccount(
    BuildContext context, String id, String email) async {
  try {
    // Query Firestore to find the user with the matching id and email
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: id)
        .where('email', isEqualTo: email)
        .get();

    // Check if any matching user exists
    if (querySnapshot.docs.isEmpty) {
      throw Exception("No user found with the provided ID and email.");
    }

    // Assuming there's only one match
    String userId = querySnapshot.docs.first.id;

    // Update the status field to 'Inactive'
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'status': 'Inactive'});

    print("Officer account deactivated successfully.");

    // Pop up: Success
    CustomDialog.showDialogBox(context,
        title: "Success", message: "Officer account deactivated successfully.");
  } catch (e) {
    print("Error deactivating officer account: $e");

    // Pop up: Error
    CustomDialog.showDialogBox(context,
        title: "Error", message: "Failed to deactivate officer account: $e");
  }
}
