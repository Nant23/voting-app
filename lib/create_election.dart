import 'package:flutter/material.dart';
import 'components/my_textfield.dart';

class CreateElection extends StatelessWidget {
  final TextEditingController electionNameController = TextEditingController();
  final TextEditingController option1Controller = TextEditingController();
  final TextEditingController option2Controller = TextEditingController();
  final TextEditingController option3Controller = TextEditingController();

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
                  hintStyle: const TextStyle(fontSize: 18),
                ),

                const SizedBox(height: 20),

                // Option 1
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '1.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextfield(
                        controller: option1Controller,
                        hintText: 'Option',
                        obscureText: false,
                        hintStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Option 2
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '2.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextfield(
                        controller: option2Controller,
                        hintText: 'Option',
                        obscureText: false,
                        hintStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Option 3
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(
                        child: Text(
                          '3.',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: MyTextfield(
                        controller: option3Controller,
                        hintText: 'Option',
                        obscureText: false,
                        hintStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                
                ElevatedButton(
                  onPressed: () {
                    // Logic to create the election
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
                    'Publish Election',
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
    );
  }
}
