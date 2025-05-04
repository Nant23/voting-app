import 'package:flutter/material.dart';
import 'package:voting_app/admin/admin_statistics.dart';
import 'package:voting_app/admin/remove_user.dart';
import 'package:voting_app/admin/view_result_ad.dart';
import 'package:voting_app/admin/admin_nav.dart';
import 'package:voting_app/admin/officer_reg.dart';

class AdminDash extends StatefulWidget {
  final int selectedIndex;

  AdminDash({this.selectedIndex = 0}); //default to 0

  @override
  _AdminDashState createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
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
      appBar: AppBar(title: Text('Admin')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Officer Registration Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfficerReg()),
                );
              },
              child: Text('Officers Register',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 20),

            // Voters Registration Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RemoveUser()),
                );
              },
              child: Text('Remove Users',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 20),

            // View Result Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewResultAd()),
                );
              },
              child: Text('View Result',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 20),

            // Election Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminStatistics()),
                );
              },
              child: Text('Report',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      // Nav Bar
      bottomNavigationBar: NavBar(
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