import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdEditProfile extends StatefulWidget {
  final String uid; // Firestore document ID

  AdEditProfile({required this.uid});

  @override
  _AdEditProfileState createState() => _AdEditProfileState();
}

class _AdEditProfileState extends State<AdEditProfile> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final countryController = TextEditingController();

  bool _hasInitialized = false; // Prevents re-initializing controllers

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    countryController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
    final updatedName = nameController.text.trim();
    final updatedEmail = emailController.text.trim();
    final updatedCountry = countryController.text.trim();

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
        const SnackBar(content: Text('Profile updated successfully!')),
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
        appBar: AppBar(title: const Text("Edit Profile")),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text('Error loading user data'));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: CircularProgressIndicator());
            }

            final data = snapshot.data!.data() as Map<String, dynamic>;

            // Initialize controllers once with data from Firestore
            if (!_hasInitialized) {
              nameController.text = data['name'] ?? '';
              emailController.text = data['email'] ?? '';
              countryController.text = data['country'] ?? '';
              _hasInitialized = true;
            }

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: "Email"),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: countryController,
                    decoration: const InputDecoration(labelText: "Country"),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.save),
                    label: const Text("Save Changes"),
                    onPressed: saveChanges,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}
