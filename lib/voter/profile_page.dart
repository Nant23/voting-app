import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFB3C3D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: const [
          SizedBox(height: 24),
          Text(
            'Profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Profile info coming soon!',
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}