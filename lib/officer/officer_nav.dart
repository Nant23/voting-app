import 'package:flutter/material.dart';
import 'package:voting_app/officer/officer_dashboard.dart';
import 'package:voting_app/officer/create_election.dart';
import 'package:voting_app/officer/officer_profile.dart';
import 'view_result_off.dart';

class NavbarOff extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const NavbarOff({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget destination;
    switch (index) {
      case 0:
        destination = Officer(selectedIndex: index);
        break;
      case 1:
        destination = CreateElection(selectedIndex: index);
        break;
      case 2:
        destination = ViewResult(selectedIndex: index);
        break;
      case 3:
        destination = Profile(selectedIndex: index);
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        _onNavTap(context, index);
        onTap(index);
      },
      selectedItemColor: Color(0xFF46639B),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote), label: 'Create Election'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Result'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
