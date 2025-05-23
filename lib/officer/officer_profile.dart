import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/officer/edit_profile.dart';
import 'package:voting_app/officer/officer_nav.dart';
import 'package:voting_app/login.dart';

class Profile extends StatefulWidget {
  final int selectedIndex;

  Profile({this.selectedIndex = 4});

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 0;
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
    final uid = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.network(
              "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFBED2EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: userData == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.account_circle,
                            size: 140,
                            color: Colors.black87,
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (uid != null) {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfilePage(uid: uid),
                                  ),
                                );

                                // If profile was updated
                                if (result != null && mounted) {
                                  setState(() {
                                    userData?['name'] = result['name'];
                                    userData?['email'] = result['email'];
                                    userData?['country'] = result['country'];
                                  });
                                }
                              }
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit Profile"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
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
                    Center(
                      child: Text(
                        userData?['email'] ?? 'email',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildInfoLabel('Country', userData?['country']),
                    const SizedBox(height: 15),
                    _buildInfoLabel('ID', userData?['id']),
                    const SizedBox(height: 15),
                    _buildInfoLabel('User Type', userData?['role']),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Log Out
                        OutlinedButton(
                          onPressed: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Logout'),
                                content: const Text(
                                    'Are you sure you want to log out?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Log Out'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              FirebaseAuth.instance.signOut();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            }
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: const BorderSide(color: Colors.red),
                          ),
                          child: const Text('Log Out'),
                        ),

                        // Delete Account
                        ElevatedButton(
                          onPressed: () async {
                            bool? confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Deletion'),
                                content: const Text(
                                  'Are you sure you want to delete your account? This action cannot be undone.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                    ),
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              try {
                                final user = FirebaseAuth.instance.currentUser;
                                if (user != null) {
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(user.uid)
                                      .delete();
                                  await user.delete();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()),
                                  );
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Error deleting account: $e'),
                                  ),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text(
                            'Delete Account',
                            style: TextStyle(color: Colors.white),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        '$label: ${value?.toString() ?? 'N/A'}',
        style: _valueStyle,
      ),
    );
  }
}

const TextStyle _valueStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
);
