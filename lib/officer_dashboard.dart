import 'package:flutter/material.dart';
import 'officer_nav.dart';
import 'create_election.dart';
import 'view_result.dart';

class Officer extends StatefulWidget {
  final int selectedIndex;

  Officer({this.selectedIndex = 0});

  @override
  State<Officer> createState() => _OfficerState();
}

class _OfficerState extends State<Officer> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Officer Dashboard'),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, size: 28), // Menu icon
            onSelected: (String value) {
              // Handle menu actions
              print("Selected: $value");
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'Profile',
                child: Text('Profile'),
              ),
              PopupMenuItem<String>(
                value: 'Settings',
                child: Text('Settings'),
              ),
              PopupMenuItem<String>(
                value: 'Logout',
                child: Text('Logout'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Color(0xFFBED2EE), // Background color

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center everything
        children: [
          Spacer(), // Pushes everything downward

          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 30), // Add padding for alignment
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateElection(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF46639B),
                minimumSize: Size(double.infinity, 70), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Create Election",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26, // Bigger font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20), // Space between buttons

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewResult(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF46639B),
                minimumSize: Size(double.infinity, 70), // Full width button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "View Result",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26, // Bigger font
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Spacer(), // Pushes buttons up a bit for better positioning
        ],
      ),

      bottomNavigationBar: NavbarOff(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
