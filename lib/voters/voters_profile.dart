import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../officer/officer_nav.dart';
import 'package:voting_app/login.dart';

class Profile extends StatefulWidget {
  final int selectedIndex;

  Profile({this.selectedIndex = 4});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 4;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        setState(() {
          userData = doc.data() as Map<String, dynamic>;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: userData == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Icon(
                        Icons.account_circle,
                        size: 140,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        userData?['name'] ?? 'User Name',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    //Email
                    Center(
                      child: Text(
                        userData?['email'] ?? 'email',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    //other informations
                    _buildInfoLabel(
                      'Country',
                      userData?['country'],
                    ),
                    _buildInfoLabel('id', userData?['id']),
                    _buildInfoLabel('User Type', userData?['role']),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OutlinedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginPage()),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Log Out'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Delete account logic here
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Delete Account',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
        ),
      ),
      bottomNavigationBar: NavbarOff(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildInfoLabel(String label, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label', style: _labelStyle),
        const SizedBox(height: 5),
        Text(value?.toString() ?? 'N/A', style: _valueStyle),
        const SizedBox(height: 10),
      ],
    );
  }
}

const TextStyle _labelStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
  fontWeight: FontWeight.w500,
);

const TextStyle _valueStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);