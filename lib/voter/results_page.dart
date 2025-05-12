import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voting_app/single_stats.dart';

class ResultsPage extends StatelessWidget {
  const ResultsPage({super.key}); // Constructor with key

  Stream<List<String>> getQuestionIds() {
    return FirebaseFirestore.instance
        .collection('questions')
        .where('status', isEqualTo: 'Ongoing') // Filtering by status
        .where('publish_status',
            isEqualTo: 'Published') // Filtering by publish_status
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<List<String>> getPastQuestionIds() {
    return FirebaseFirestore.instance
        .collection('questions')
        .where('status', isEqualTo: 'Closed') // Filtering by status
        .where('publish_status',
            isEqualTo: 'Published') // Filtering by publish_status
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<bool> getElectionStatus() {
    return FirebaseFirestore.instance
        .collection('questions')
        .where('status', isEqualTo: 'Ongoing')
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(16),
        color: const Color(0xFFB3C3D9),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ongoing Election',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              //Ongoing
              StreamBuilder<bool>(
                stream: getElectionStatus(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || !snapshot.data!) {
                    return const Center(child: Text('No ongoing election'));
                  } else {
                    return StreamBuilder<List<String>>(
                        stream: getQuestionIds(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return const Text('Results hasn`t been published.');
                          }

                          final ids = snapshot.data!;
                          return Column(
                            children: ids.map((id) {
                              return Container(
                                margin: const EdgeInsets.only(bottom: 24),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6EDF5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                height: 400,
                                child: SingleStats(documentId: id),
                              );
                            }).toList(),
                          );
                        });
                  }
                },
              ),

              const SizedBox(height: 20),

              //Past Election
              const Text(
                'Past Elections',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),

              //to get realtime updates
              StreamBuilder<List<String>>(
                //for closed elections
                stream: getPastQuestionIds(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No results available.');
                  }

                  final ids = snapshot.data!;
                  return Column(
                    children: ids.map((id) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6EDF5),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        height: 400,
                        child: SingleStats(documentId: id),
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
