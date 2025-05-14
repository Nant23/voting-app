// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/my_textfield.dart';
import '../dialogs.dart';
import '../officer/officer_nav.dart';

class CreateElection extends StatefulWidget {
  final int selectedIndex;
  const CreateElection({super.key, this.selectedIndex = 1});

  @override
  _CreateElectionState createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  int _selectedIndex = 1;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final TextEditingController electionNameController = TextEditingController();

  List<Map<String, dynamic>> options = [
    {'controller': TextEditingController(), 'isSelected': false},
    {'controller': TextEditingController(), 'isSelected': false},
    {'controller': TextEditingController(), 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Election'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.network(
              "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFBED2EE),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  MyTextfield(
                    controller: electionNameController,
                    hintText: 'Election Name',
                    obscureText: false,
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: options.asMap().entries.map((entry) {
                      int index = entry.key;
                      return Column(
                        children: [
                          buildOptionRow(index),
                          const SizedBox(height: 10),
                        ],
                      );
                    }).toList(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              options.add({
                                'controller': TextEditingController(),
                                'isSelected': false,
                              });
                            });
                          },
                          backgroundColor: Colors.white,
                          mini: true,
                          child: const Icon(Icons.add, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      String mainQuestion = electionNameController.text.trim();
                      final uid = FirebaseAuth.instance.currentUser?.uid;

                      if (mainQuestion.isEmpty) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Error",
                          message: "Please enter an election name.",
                        );
                        return;
                      }

                      if (uid == null) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Error",
                          message: "User not logged in.",
                        );
                        return;
                      }

                      final ongoing = await FirebaseFirestore.instance
                          .collection('questions')
                          .where('status', isEqualTo: 'Ongoing')
                          .where('officer_uid', isEqualTo: uid)
                          .get();

                      if (ongoing.docs.isNotEmpty) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Election Exists",
                          message: "You already have an ongoing election.",
                        );
                        return;
                      }

                      List<String> optionTexts = options
                          .map<String>((opt) => opt['controller'].text.trim())
                          .where((text) => text.isNotEmpty)
                          .toList();

                      if (optionTexts.length < 2) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Error",
                          message: "Please enter at least 2 options.",
                        );
                        return;
                      }

                      bool success = await storeQuestionData(
                          context, optionTexts, mainQuestion, uid);

                      if (success) {
                        electionNameController.clear();
                        for (var option in options) {
                          option['controller'].clear();
                          option['isSelected'] = false;
                        }
                        setState(() {});
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46639B),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 60,
                        vertical: 20,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Publish',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavbarOff(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  Widget buildOptionRow(int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.black, width: 2),
          ),
          child: Checkbox(
            value: options[index]['isSelected'],
            onChanged: (bool? newValue) {
              setState(() {
                options[index]['isSelected'] = newValue ?? false;
              });
            },
            activeColor: Colors.white,
            checkColor: Colors.black,
            side: BorderSide.none,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: MyTextfield(
            controller: options[index]['controller'],
            hintText: 'Option ${index + 1}',
            obscureText: false,
          ),
        ),
      ],
    );
  }
}


//backend
// This function will store the questions along with options in database
Future<bool> storeQuestionData(
  BuildContext context,
  List<String> questionsArray,
  String mainQuestion,
  String uid,
) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference questionsRef = firestore.collection('questions');
  final CollectionReference usersRef = firestore.collection('users');

  try {
    // Get the latest election ID
    QuerySnapshot snapshot =
        await questionsRef.orderBy('id', descending: true).limit(1).get();
    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      int lastId = snapshot.docs.first['id'] ?? 0;
      nextId = lastId + 1;
    }

    // Fetch officer's name using uid
    DocumentSnapshot userDoc = await usersRef.doc(uid).get();
    String officerName = '';
    if (userDoc.exists) {
      officerName = userDoc.get('name') ?? '';
    }

    // Build election data
    Map<String, dynamic> data = {
      'id': nextId,
      'question': mainQuestion,
      'status': 'Ongoing',
      'publish_status': 'Unpublished',
      'votedUsers': <String>[],
      'officer_uid': uid,
      'officer_name': officerName, // include officer's name
    };

    // Add options and vote counters
    for (int i = 0; i < questionsArray.length; i++) {
      data['question ${i + 1}'] = questionsArray[i];
      data['q${i + 1}_votes'] = 0;
    }

    // Save to Firestore
    await questionsRef.add(data);
    print("Election saved successfully.");

    CustomDialog.showDialogBox(
      context,
      title: "Success",
      message: "Election Created",
    );
    return true;
  } catch (e) {
    print("Error saving election: $e");
    return false;
  }
}


