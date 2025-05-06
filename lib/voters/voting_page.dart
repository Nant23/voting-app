// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:voting_app/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'voting_screen.dart';
import 'package:voting_app/dialogs.dart';
import 'package:voting_app/voters/voters_result.dart';

class VotingHomePage extends StatefulWidget {
  const VotingHomePage({super.key});

  @override
  _VotingHomePageState createState() => _VotingHomePageState();
}

class _VotingHomePageState extends State<VotingHomePage> {
  int _currentPage = 0;
  final _controllers = List.generate(5, (_) => TextEditingController());
  final _errorMessages = List<String?>.filled(5, null);
  bool _showSuccessMessage = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
      _showSuccessMessage = false;
    });
  }

  bool _validateFields() {
    bool valid = true;
    List<String> labels = ['Name', 'Age', 'Gender', 'Phone Number', 'Country'];

    for (int i = 0; i < _controllers.length; i++) {
      final text = _controllers[i].text.trim();
      if (text.isEmpty) {
        _errorMessages[i] = '${labels[i]} is required';
        valid = false;
      } else {
        _errorMessages[i] = null;
        if (i == 1) {
          final age = int.tryParse(text);
          if (age == null || age < 18) {
            _errorMessages[i] =
                age == null ? 'Invalid age format' : 'Must be 18 or older';
            valid = false;
          }
        }
      }
    }
    setState(() {});
    return valid;
  }

  Future<void> _submitToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final docRef =
        FirebaseFirestore.instance.collection('voter_registration').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already registered.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
        ),
      );
      return;
    }

    final data = {
      'id': uid,
      'Name': _controllers[0].text.trim(),
      'Age': _controllers[1].text.trim(),
      'Gender': _controllers[2].text.trim(),
      'Phone Number': _controllers[3].text.trim(),
      'Country': _controllers[4].text.trim(),
      'status': 'unregistered',
    };

    await docRef.set(data);

    setState(() {
      _showSuccessMessage = true;
      for (final controller in _controllers) {
        controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _buildPage()),
      bottomNavigationBar: _bottomBar(selectedIndex: _currentPage),
    );
  }

  Widget _buildPage() {
    if (_currentPage == 0) return _dashboard();
    if (_currentPage == 2) return _results(context);
    if (_currentPage == 3) return _profile();
    return _registerForm(showSuccess: _showSuccessMessage);
  }

  Widget _dashboard() => Container(
        width: MediaQuery.of(context).size.width,
        height:
            MediaQuery.of(context).size.height, // Ensure it fills the screen
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFB3C3D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40), // Padding from top
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 20,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}',
                  style: const TextStyle(color: Colors.black, fontSize: 18),
                ),
              ],
            ),
            const Spacer(), // Pushes the buttons to center vertically
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dashboardButton('Vote', 72, 32, 0xFF4F6596, () async {
                    final currentUser = FirebaseAuth.instance.currentUser;
                    bool isRegistered =
                        await isUserRegistered(currentUser!.uid);
                    if (isRegistered) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const VoteScreen()),
                      );
                    } else {
                      CustomDialog.showDialogBox(
                        context,
                        title: "Not registered",
                        message: "You must be a verified user to vote",
                      );
                    }
                  }),
                  const SizedBox(height: 24),
                  _dashboardButton('View result', 56, 24, 0xFF3F527F, () {
                    _changePage(2);
                  }),
                ],
              ),
            ),
            const Spacer(), // Pushes the buttons up just enough to center overall
          ],
        ),
      );

  Widget _dashboardButton(String text, double height, double fontSize,
          int color, VoidCallback? onTap) =>
      SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(color),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );

  Widget _registerForm({bool showSuccess = false}) => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFB3C3D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, size: 28),
                    color: Colors.black,
                    onPressed: () => _changePage(0),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: AbsorbPointer(
                    absorbing: showSuccess,
                    child: Opacity(
                      opacity: showSuccess ? 0.6 : 1,
                      child: SingleChildScrollView(
                        child: Column(
                          children: List.generate(
                            _controllers.length,
                            (i) => _buildTextField(i),
                          )..addAll([
                              const SizedBox(height: 24),
                              _dashboardButton(
                                'Register',
                                56,
                                32,
                                0xFF3F527F,
                                showSuccess
                                    ? null
                                    : () async {
                                        if (_validateFields()) {
                                          await _submitToFirestore();
                                        }
                                      },
                              ),
                            ]),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (showSuccess) _successOverlay(),
          ],
        ),
      );

  Widget _buildTextField(int i) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextfield(
            controller: _controllers[i],
            hintText: ['Name', 'Age', 'Gender', 'Phone Number', 'Country'][i],
            obscureText: false,
          ),
          if (_errorMessages[i] != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _errorMessages[i]!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),
        ],
      );

  Widget _successOverlay() => Positioned(
        top: 60,
        left: 0,
        right: 0,
        child: Center(
          child: Container(
            width: 192,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF7F8AA3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Expanded(
                  child: Text(
                    'Successfully\nRegistered',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      height: 1.2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _changePage(0),
                  child: const Icon(Icons.close, color: Colors.black, size: 20),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _bottomBar({required int selectedIndex}) => BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: _changePage,
        selectedItemColor: const Color(0xFF46639B),
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.app_registration), label: 'Register'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Result'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      );
  Widget _results(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          try {
            final querySnapshot = await FirebaseFirestore.instance
                .collection('results')
                .limit(1)
                .get();

            if (querySnapshot.docs.isNotEmpty) {
              final doc = querySnapshot.docs.first;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => VotersResult(documentId: doc.id),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No results found')),
              );
            }
          } catch (e) {
            print('Error fetching results: $e');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to load results')),
            );
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFB3C3D9),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(height: 8),
              Text(
                'Results',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Tap to view latest voting results',
                style: TextStyle(fontSize: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profile() => Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFB3C3D9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: const [
            SizedBox(height: 24),
            Text(
              'Profile',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Profile info coming soon!',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      );
}

Future<bool> isUserRegistered(String uid) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('voter_registration')
        .doc(uid)
        .get();

    if (!doc.exists) return false;
    var data = doc.data() as Map<String, dynamic>;
    return data['status'] == 'registered';
  } catch (e) {
    print('Error checking registration status: $e');
    return false;
  }
}
