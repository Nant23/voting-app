import 'package:flutter/material.dart';
import 'admin_nav.dart';

class VotersInfoPage extends StatefulWidget {
  final int selectedIndex;

  const VotersInfoPage({this.selectedIndex = 2, super.key});

  @override
  _VotersInfoPageState createState() => _VotersInfoPageState();
}

class _VotersInfoPageState extends State<VotersInfoPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      body: const SizedBox(), // Empty body, only background
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
