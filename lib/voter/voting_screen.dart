import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'electioncard.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(
  title: Text('Vote'),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Image.network(
        "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
        height: 60, // Adjust size as needed
        width: 60,
        fit: BoxFit.contain,
      ),
    ),
  ],
),
      body: FutureBuilder<QuerySnapshot>(
        future: firestore
            .collection('questions')
            .where('status', isEqualTo: 'Ongoing')
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No ongoing elections."));
          }

          final elections = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: elections.length,
            itemBuilder: (context, index) {
              final doc = elections[index];
              return ElectionCard(doc: doc);
            },
          );
        },
      ),
    );
  }
}
