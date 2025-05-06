import 'package:flutter/material.dart';
import 'package:voting_app/single_stats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VotersResult extends StatefulWidget {
  final int selectedIndex;
  final String documentId;

  const VotersResult({
    super.key,
    this.selectedIndex = 0,
    required this.documentId,
  });

  @override
  _VotersResultState createState() => _VotersResultState();
}

class _VotersResultState extends State<VotersResult> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFBED2EE),
        elevation: 0,
        title: const Text(
          'Election Results',
          style: TextStyle(
            color: Color(0xFF2C3E50),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              const Text(
                'Result of Current Election',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) {
                  return SizedBox(
                    height:
                        constraints.maxHeight * 0.8, // 80% of available height
                    child: SingleStats(documentId: widget.documentId),
                  );
                },
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      // Uncomment and connect Navbar if needed
      // bottomNavigationBar: Navbar(
      //   currentIndex: _selectedIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
