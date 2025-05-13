import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'officer_nav.dart';
import 'package:voting_app/dialogs.dart';
import 'package:voting_app/single_stats.dart';

class DetailsPage extends StatefulWidget {
  final int selectedIndex;
  final String documentId;

  const DetailsPage({
    super.key,
    this.selectedIndex = 2,
    required this.documentId,
  });

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
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
        title: const Text(
          'Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      backgroundColor: const Color(0xFFBED2EE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Details',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),

              // Embedded detailed chart for the selected question
              SizedBox(
                height: 500, // Adjust the height as needed
                child: SingleStats(documentId: widget.documentId),
              ),

              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    bool confirm = await showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Publish'),
                        content: const Text('Are you sure you want to publish the result?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('No'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Yes'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm == true) {
                    await publishResult(context);
                  }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF46639B),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Publish Result',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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

Future<void> publishResult(BuildContext context) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('publish_status', isEqualTo: 'Unpublished')
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String documentId = querySnapshot.docs.first.id;

      await FirebaseFirestore.instance
          .collection('questions')
          .doc(documentId)
          .update({'publish_status': 'Published'});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Result published successfully.')),
      );
    }
  } catch (e) {
    CustomDialog.showDialogBox(
      context,
      title: "Error",
      message: "Failed to publish result: $e",
    );
  }
}
