import 'package:flutter/material.dart';
import 'components/my_textfield.dart';
import 'dialogs.dart';
import 'package:voting_app/officer/officer_nav.dart';

class CreateElection extends StatefulWidget {
  final int selectedIndex;
  CreateElection({this.selectedIndex = 1});

  @override
  _CreateElectionState createState() => _CreateElectionState();
}

class _CreateElectionState extends State<CreateElection> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
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
      body: SafeArea(
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
                  mainAxisAlignment:
                      MainAxisAlignment.start, // Adjust alignment
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 6), // Move it slightly left
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
                  onPressed: () {
                    // Logic to create the election
                    CustomDialog.showDialogBox(
                      context,
                      title: "Success",
                      message: "Election Created",
                    );
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
      bottomNavigationBar: NavbarOff(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
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

//hello
