import 'package:flutter/material.dart';
import 'navigation_bar.dart';
import 'create_election.dart';

class Officer extends StatefulWidget {
  const Officer({super.key});

  @override
  State<Officer> createState() => _OfficerState();
}

class _OfficerState extends State<Officer> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
            padding: const EdgeInsets.symmetric(horizontal: 30), // Add padding for alignment
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
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ResultsPage(),
                //   ),
                // );
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

      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
