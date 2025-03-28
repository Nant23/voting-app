import 'package:flutter/material.dart';
import 'textfield_wid.dart';
import 'navigation_bar.dart';

class OfficerReg extends StatefulWidget {
  const OfficerReg({Key? key}) : super(key: key);

  @override
  _OfficerRegState createState() => _OfficerRegState();
}

class _OfficerRegState extends State<OfficerReg> {
  final TextEditingController officerIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController countryController = TextEditingController();

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
      appBar: AppBar(title: Text('Officer Registration')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            textfield_wid(label: 'Officer ID', controller: officerIdController),
            textfield_wid(label: 'Name', controller: nameController),
            textfield_wid(
                label: 'Password',
                controller: passwordController,
                obscureText: true),
            textfield_wid(
                label: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: true),
            textfield_wid(label: 'Country', controller: countryController),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Add'),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Text('Remove'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
      ),
    );
  }
}
