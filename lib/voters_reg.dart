import 'package:flutter/material.dart';
import 'textfield_wid.dart';
import 'navigation_bar.dart';
//import 'dialogs.dart';

class VotersReg extends StatefulWidget {
  const VotersReg({Key? key}) : super(key: key);

  @override
  _VotersRegState createState() => _VotersRegState();
}

class _VotersRegState extends State<VotersReg> {
  final TextEditingController voterIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(title: Text('Voter Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              textfield_wid(label: 'Voter ID', controller: voterIdController),
              textfield_wid(label: 'Name', controller: nameController),
              textfield_wid(
                  label: 'Password',
                  controller: passwordController,
                  obscureText: true),
              textfield_wid(
                  label: 'Confirm Password',
                  controller: confirmPassController,
                  obscureText: true),
              textfield_wid(label: 'Country', controller: countryController),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46639B),
                    ),
                    onPressed: () {
                      // createVoterAccount(
                      //     // context,
                      //     passwordController.text,
                      //     nameController.text,
                      //     countryController.text,
                      //     voterIdController.text);
                    },
                    child: Text('Add', style: TextStyle(color: Colors.white)),
                  ),
                  OutlinedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                    ),
                    onPressed: () {},
                    child: Text('Remove',
                        style: TextStyle(color: Color(0xFF46639B))),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
