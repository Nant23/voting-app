import 'package:flutter/material.dart';
import 'officer_nav.dart';
import 'create_election.dart';
import 'view_result_off.dart';
import 'package:voting_app/dialogs.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            icon: Icon(Icons.menu, size: 28),
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
      backgroundColor: const Color(0xFFBED2EE),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(),

          // Create Election Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
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
                minimumSize: Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Create Election",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Close Ongoing Election Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: ElevatedButton(
              onPressed: () async {
                final firestore = FirebaseFirestore.instance;

                try {
                  // Get the ongoing election
                  final snapshot = await firestore
                      .collection('questions')
                      .where('status', isEqualTo: 'Ongoing')
                      .limit(1)
                      .get();

                  if (snapshot.docs.isEmpty) {
                    CustomDialog.showDialogBox(
                      context,
                      title: "No Election",
                      message: "There is no ongoing election to close.",
                    );
                    return;
                  }

                  final docId = snapshot.docs.first.id;

                  // Update the status to 'Closed'
                  await firestore.collection('questions').doc(docId).update({
                    'status': 'Closed',
                  });

                  CustomDialog.showDialogBox(
                    context,
                    title: "Success",
                    message: "Election closed successfully.",
                  );
                } catch (e) {
                  print("Error closing election: $e");
                  CustomDialog.showDialogBox(
                    context,
                    title: "Error",
                    message: "Failed to close election. Please try again.",
                  );
                }
              },


              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF46639B),
                minimumSize: Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Close Ongoing Election",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // View Result Button
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
                minimumSize: Size(double.infinity, 70),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "View Result",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Spacer(),
        ],
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