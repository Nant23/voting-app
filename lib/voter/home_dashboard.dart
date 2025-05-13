import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voting_app/voter/voting_screen.dart';
import 'voter_filtered_results.dart';
import '../dialogs.dart';
import '../utilities.dart';
//import 'voters_nav_bar.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  String userName = 'User';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        setState(() {
          userName = data['userName'] ?? 'User';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi, $userName!'),
      ),
      backgroundColor: const Color(0xFFBED2EE),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _dashboardButton('Vote', 0xFF46639B, () async {
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
                  _dashboardButton('View result', 0xFF46639B, () {
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
      ),
    );
  }

  Widget _dashboardButton(String text, int color, VoidCallback? onTap) =>
      SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(color),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
}

