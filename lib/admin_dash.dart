import 'package:flutter/material.dart';
import 'package:voting_app/voters_reg.dart';
import 'navigation_bar.dart';
import 'officer_reg.dart';

class AdminDash extends StatefulWidget {
  @override
  _AdminDashState createState() => _AdminDashState();
}

class _AdminDashState extends State<AdminDash> {
  //navbar current index
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  MaterialPageRoute(builder: (context) => VotersReg()),
                );
              },
              child: Text('Voters Register',
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
              onPressed: () {},
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
              onPressed: () {},
              child: Text('Election',
                  style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
            SizedBox(height: 20),

            // In Progress
            Text('In Progress: -',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            //In Progress Items
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF919CB6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF919CB6),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ],
        ),
      ),
      //Nav Bar
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
