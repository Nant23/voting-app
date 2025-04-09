import 'package:flutter/material.dart';

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
        backgroundColor: const Color(0xFF46639B),
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
              _buildStatItem('Total Elections: 15'),
              _buildStatItem('Total Votes Cast: 2000'),
              _buildStatItem('Total Users: 1200'),
              const SizedBox(height: 40),
              _buildStatItem('Active Elections: 5'),
              _buildStatItem('Upcoming Elections: 2'),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Add logic to refresh or fetch new data if needed
                },
                child: const Text('Refresh Stats'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF46639B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String stat) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            stat,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
