import 'package:flutter/material.dart';
import 'components/my_textfield.dart';
import 'dialogs.dart';
import 'navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateElection extends StatefulWidget {
  @override
  _CreateElectionState createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final TextEditingController electionNameController = TextEditingController();

  // List to store dynamically added options
  List<Map<String, dynamic>> options = [
    {'controller': TextEditingController(), 'isSelected': false},
    {'controller': TextEditingController(), 'isSelected': false},
    {'controller': TextEditingController(), 'isSelected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        
                  // Build dynamic option rows
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
        
                  // Plus icon button to add new options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start, // Adjust alignment
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 6), // Move it slightly left
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
                          child: const Icon(Icons.add, color: Colors.black),
                          mini: true,
                        ),
                      ),
                    ],
                  ),
        
                  const SizedBox(height: 30),
        
                  ElevatedButton(
                    onPressed: () async {
                      String mainQuestion = electionNameController.text.trim();

                      if (mainQuestion.isEmpty) {
                        CustomDialog.showDialogBox(
                          context,
                          title: "Error",
                          message: "Please enter an election name.",
                        );
                        return;
                      }

                      // Collect non-empty options
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

                      await storeQuestionData(context, optionTexts, mainQuestion);
                      
                      // CustomDialog.showDialogBox(
                      //   context,
                      //   title: "Success",
                      //   message: "Election Created",
                      // );
                      
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
                      'Public Election',
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
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }

  // Build each row dynamically
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

Future<void> storeQuestionData(BuildContext context, List<String> questionsArray, String mainQuestion) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference questionsRef = firestore.collection('questions');

  try {
    // Get the current max ID (auto-increment logic)
    QuerySnapshot snapshot = await questionsRef.orderBy('id', descending: true).limit(1).get();
    int nextId = 1;
    if (snapshot.docs.isNotEmpty) {
      int lastId = snapshot.docs.first['id'] ?? 0;
      nextId = lastId + 1;
    }

    // Create the question data
    Map<String, dynamic> data = {
      'id': nextId,
      'question': mainQuestion,
      'status': 'Ongoing',
    };

    for (int i = 0; i < questionsArray.length; i++) {
      data['question ${i + 1}'] = questionsArray[i];
    }

    await questionsRef.add(data);
    print("Election saved successfully.");
    CustomDialog.showDialogBox(
      context,
      title: "Success",
      message: "Election Created",
    );
    
  } catch (e) {
    print("Error saving election: $e");
  }
}

