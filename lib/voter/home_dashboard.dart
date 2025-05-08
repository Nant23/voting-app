import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/voter/voting_screen.dart';
import 'voter_filtered_results.dart';
import '../dialogs.dart';
import '../utilities.dart';
//import 'voters_nav_bar.dart';

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFB3C3D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.black,
                radius: 20,
                child: Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Text(
                'Hi, ${FirebaseAuth.instance.currentUser?.displayName ?? "User"}',
                style: const TextStyle(color: Colors.black, fontSize: 18),
              ),
            ],
          ),
          const Spacer(),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _dashboardButton('Vote', 72, 32, 0xFF4F6596, () async {
                  final currentUser = FirebaseAuth.instance.currentUser;
                  bool isRegistered = await isUserRegistered(currentUser!.uid);
                  if (isRegistered) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VoteScreen()),
                    );
                  } else {
                    CustomDialog.showDialogBox(
                      context,
                      title: "Not registered",
                      message: "You must be a verified user to vote",
                    );
                  }
                }),
                const SizedBox(height: 24),
                _dashboardButton('View result', 56, 24, 0xFF3F527F, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const VoterStatistics()),
                    );
                }),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _dashboardButton(String text, double height, double fontSize,
          int color, VoidCallback? onTap) =>
      SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
}