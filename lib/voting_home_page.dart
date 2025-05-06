import 'package:flutter/material.dart';
import 'home_dashboard.dart';
import 'register_form.dart';
import 'results_page.dart';
import 'profile_page.dart';

class VotingHomePage extends StatefulWidget {
  final int initialPage;
  
  const VotingHomePage({
    super.key,
    this.initialPage = 0,
  });

  @override
  State<VotingHomePage> createState() => _VotingHomePageState();
}

class _VotingHomePageState extends State<VotingHomePage> {
  late int _currentPage;
  final List<Widget> _pages = [
    const HomeDashboard(),
    const RegisterForm(),
    const ResultsPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
  }

  void _changePage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentPage],
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  BottomNavigationBar _buildBottomNavBar() => BottomNavigationBar(
    currentIndex: _currentPage,
    onTap: _changePage,
    selectedItemColor: const Color(0xFF46639B),
    unselectedItemColor: Colors.black,
    items: const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(
        icon: Icon(Icons.app_registration), label: 'Register'),
      BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Result'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  );
}