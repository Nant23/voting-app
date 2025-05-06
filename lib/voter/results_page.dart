import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/single_stats.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key});

  Future<List<String>> fetchQuestionIds() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('questions').get();
    return snapshot.docs.map((doc) => doc.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: const Color(0xFF4F6596),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFB3C3D9),
        child: FutureBuilder<List<String>>(
          future: fetchQuestionIds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No results available.'));
            }

            final ids = snapshot.data!;
            return ListView.separated(
              itemCount: ids.length,
              separatorBuilder: (context, index) => const SizedBox(height: 24),
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6EDF5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SizedBox(
                    height:
                        400, // Adjust based on how much space SingleStats needs
                    child: SingleStats(documentId: ids[index]),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
