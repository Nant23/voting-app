import 'package:flutter/material.dart';
import 'package:voting_app/admin/admin_result.dart';
import 'package:voting_app/admin/admin_statistics.dart';
import 'package:voting_app/admin/remove_user.dart';
import 'package:voting_app/admin/admin_nav.dart';
import 'package:voting_app/admin/officer_reg.dart';

class AdminDash extends StatefulWidget {
  final int selectedIndex;

  const AdminDash({super.key, this.selectedIndex = 0});

  @override
  State<AdminDash> createState() => _AdminDashState();
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
      appBar: AppBar(
        title: Text('Admin'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.network(
              "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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

              // Remove Users Button
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

              // Past Election Button
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
                child: Text('Past Election',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 20),

              // Report Button
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
                    MaterialPageRoute(builder: (context) => ElectionResultsPage()),
                  );
                },
                child: Text('Report',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
              SizedBox(height: 40),

              // Bottom faded logo
              Opacity(
                opacity: 0.5,
                child: Image.network(
                  "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
                  height: 300,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
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
