 import 'package:flutter/material.dart';

class OfficerNavBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int) onTap;

  const OfficerNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Color(0xFF46639B),
      unselectedItemColor: Colors.black,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote), label: 'create election'),
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'result'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
