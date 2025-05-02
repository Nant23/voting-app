import 'package:flutter/material.dart';
import 'package:voting_app/admin/admin_nav.dart';

//Dummy DATA
class Stats extends StatefulWidget {
  final int selectedIndex;

  Stats({this.selectedIndex = 3});

  @override
  _StatsState createState() => _StatsState();
}

class _StatsState extends State<Stats> {
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
        title: const Text('Statistics'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Voting Statistics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 30),
              Text('Total Elections: 15'),
              Text('Total Votes Cast: 2000'),
              Text('Total Users: 1200'),
              const SizedBox(height: 40),
              Text('Active Elections: 5'),
              Text('Upcoming Elections: 2'),
              const SizedBox(height: 30),
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