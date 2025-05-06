import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../dialogs.dart';

class ElectionCard extends StatefulWidget {
  final DocumentSnapshot doc;
  const ElectionCard({required this.doc});

  @override
  State<ElectionCard> createState() => _ElectionCardState();
}

class _ElectionCardState extends State<ElectionCard> {
  String? selectedOptionKey;

  @override
  Widget build(BuildContext context) {
    final data = widget.doc.data() as Map<String, dynamic>;
    final question = data['question'];
    final optionEntries =
        data.entries.where((e) => e.key.startsWith('question ')).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(question,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 12),
            Column(
              children: optionEntries.map((entry) {
                return RadioListTile(
                  title: Text(entry.value),
                  value: entry.key,
                  groupValue: selectedOptionKey,
                  onChanged: (value) {
                    setState(() {
                      selectedOptionKey = value.toString();
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedOptionKey == null
                  ? null
                  : () async {
                      await submitVote(widget.doc.id, selectedOptionKey!);
                    },
              child: const Text("Submit Vote"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF46639B),
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> submitVote(String docId, String optionKey) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      CustomDialog.showDialogBox(
        context,
        title: "Not Logged In",
        message: "You must be logged in to vote.",
      );
      return;
    }

    final voteField = 'q${optionKey.split(" ").last}_votes';
    final docRef =
        FirebaseFirestore.instance.collection('questions').doc(docId);

    try {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final snapshot = await transaction.get(docRef);

        List<dynamic> votedUsers = snapshot['votedUsers'] ?? [];

        if (votedUsers.contains(uid)) {
          throw Exception("You have already voted.");
        }

        final currentVotes = snapshot[voteField] ?? 0;
        transaction.update(docRef, {
          voteField: currentVotes + 1,
          'votedUsers': FieldValue.arrayUnion([uid]),
        });
      });

      CustomDialog.showDialogBox(
        context,
        title: "Vote Submitted",
        message: "Thanks for voting!",
      );

      setState(() {
        selectedOptionKey = null;
      });
    } catch (e) {
      print("Vote error: $e");

      CustomDialog.showDialogBox(
        context,
        title: "Error",
        message: e.toString().contains('already voted')
            ? "You have already voted in this election."
            : "Failed to submit vote.",
      );
    }
  }
}
