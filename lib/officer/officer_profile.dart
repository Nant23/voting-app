import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                'User Name',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),
              const Center(
                child: Icon(
                  Icons.account_circle,
                  size: 120,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),
              const Text('Name:-', style: _labelStyle),
              const SizedBox(height: 10),
              const Text('Age:-', style: _labelStyle),
              const SizedBox(height: 10),
              const Text('Country:-', style: _labelStyle),
              const SizedBox(height: 10),
              const Text('Gender:-', style: _labelStyle),
              const SizedBox(height: 10),
              const Text('User Type:-', style: _labelStyle),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      // Log out logic
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
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
                      // Delete account logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Delete Account'),
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
}

const TextStyle _labelStyle = TextStyle(
  fontSize: 16,
  color: Colors.black87,
  fontWeight: FontWeight.w500,
);
