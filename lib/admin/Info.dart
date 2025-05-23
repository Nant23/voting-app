import 'package:flutter/material.dart';
import 'admin_nav.dart';
import 'voters_info.dart';
import 'officers_info.dart';

class InfoPage extends StatefulWidget {
  final int selectedIndex;

  const InfoPage({super.key, this.selectedIndex = 2});

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text('Informations'),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Image.network(
        "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
        height: 60, // Adjust size as needed
        width: 60,
        fit: BoxFit.contain,
      ),
    ),
  ],
),
      backgroundColor: const Color(0xFFBED2EE),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VotersInfoPage()),
                );
              },
              child: Text(
                'Voters Info',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF46639B),
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OfficersInfoPage()),
                );
                // Add navigation to Officers Info page here (if needed)
              },
              child: Text(
                'Officers Info',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
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
