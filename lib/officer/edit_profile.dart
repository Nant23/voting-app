import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditProfilePage extends StatefulWidget {
  final String currentName;
  final String currentEmail;
  final String currentCountry;
  final String uid; // Firestore document ID

  EditProfilePage({
    required this.currentName,
    required this.currentEmail,
    required this.currentCountry,
    required this.uid,
  });

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController countryController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    emailController = TextEditingController(text: widget.currentEmail);
    countryController = TextEditingController(text: widget.currentCountry);
  }

  Future<void> saveChanges() async {
    String updatedName = nameController.text.trim();
    String updatedEmail = emailController.text.trim();
    String updatedCountry = countryController.text.trim();

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .update({
        'name': updatedName,
        'email': updatedEmail,
        'country': updatedCountry,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context, {
        'name': updatedName,
        'email': updatedEmail,
        'country': updatedCountry,
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 12),
            TextField(
              controller: countryController,
              decoration: InputDecoration(labelText: "Country"),
            ),
            SizedBox(height: 30),
            ElevatedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save Changes"),
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
