import 'package:flutter/material.dart';
import 'package:voting_app/Info.dart';
import 'package:voting_app/admin/admin_dash.dart';
import 'package:voting_app/admin/admin_profile.dart';
import 'package:voting_app/admin/stats.dart';
import 'package:voting_app/voter_requests.dart';

//reusable Bottom Navigation Bar for the admin section
class NavBar extends StatelessWidget {
  final int currentIndex; //current active index
  final void Function(int) onTap; //callback to update index in parent widget

  const NavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  void _onNavTap(BuildContext context, int index) {
    if (index == currentIndex) {
      return; //do nothing if already on the selected page
    }

    //navigate based on index
    Widget destination;
    switch (index) {
      case 0:
        destination = AdminDash(selectedIndex: index);
        break;
      case 1:
        destination = VoterRequests(selectedIndex: index);
        break;
      case 2:
        destination = InfoPage(selectedIndex: index);
        break;
      case 3:
        destination = Stats(selectedIndex: index);
        break;
      case 4:
        destination = ProfilePage(selectedIndex: index);
        break;
      default:
        return; // Exit if index is not valid
    }

    //replace current screen with the selected one
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
        _onNavTap(context, index); //calling the navigation method
        onTap(index); //currentIndex update in the parent
      },
      selectedItemColor: Color(0xFF46639B),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Requests'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Stats'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
