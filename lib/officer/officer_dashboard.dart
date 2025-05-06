import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'officer_nav.dart';
import 'create_election.dart';
import 'view_result_off.dart';
//import 'package:voting_app/dialogs.dart';

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
      ),
      backgroundColor: const Color(0xFFBED2EE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Create Election Button
              ElevatedButton(
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
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Create Election",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // match admin dashboard
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Close Ongoing Election Button
              ElevatedButton(
                onPressed: () async {
                  bool confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Confirm Action'),
                        content: Text(
                            'Are you sure you want to close the ongoing election?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: Text('Yes, Close'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    closeElection(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF46639B),
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "Close Ongoing Election",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // match admin dashboard
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // View Result Button
              ElevatedButton(
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
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text(
                  "View Result",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16, // match admin dashboard
                  ),
                ),
              ),
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

// Closing election by finding its document first
Future<void> closeElection(BuildContext context) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('status', isEqualTo: 'Ongoing')
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String documentId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection('questions')
          .doc(documentId)
          .update({'status': 'Closed'});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Election closed successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No ongoing election found.')),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to close election: $e')),
    );
  }
}
