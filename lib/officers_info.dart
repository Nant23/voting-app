import 'package:flutter/material.dart';
import 'admin/admin_nav.dart';

class OfficersInfoPage extends StatefulWidget {
  final int selectedIndex;

  const OfficersInfoPage({this.selectedIndex = 2});

  @override
  _OfficersInfoPageState createState() => _OfficersInfoPageState();
}

class _OfficersInfoPageState extends State<OfficersInfoPage> {
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
      body: Center(
        child: Text(
          'Officers Info Page eh',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
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
