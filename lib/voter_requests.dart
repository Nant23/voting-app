import 'package:flutter/material.dart';
import 'admin_nav.dart';

class VoterRequests extends StatefulWidget {
  final int selectedIndex;

  VoterRequests({this.selectedIndex = 1}); // Default to 1

  @override
  _VoterRequestsState createState() => _VoterRequestsState();
}

class _VoterRequestsState extends State<VoterRequests> {
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
      appBar: AppBar(title: Text('Voter Requests')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
              ),
              onPressed: () {},
              child: Text(
                'Accept',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
              ),
              onPressed: () {
                // Reject logic
              },
              child: Text(
                'Reject',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
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
