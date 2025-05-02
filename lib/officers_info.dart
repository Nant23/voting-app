import 'package:flutter/material.dart';
import 'admin/admin_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfficersInfoPage extends StatefulWidget {
  final int selectedIndex;

  const OfficersInfoPage({super.key, this.selectedIndex = 2});

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
      appBar: AppBar(title: Text('Officers')),
      backgroundColor: const Color(0xFFBED2EE),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('role', isEqualTo: 'Officer')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final officers = snapshot.data!.docs;

          if (officers.isEmpty) {
            return Center(child: Text('No officers found.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: officers.length,
            itemBuilder: (context, index) {
              final data = officers[index].data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['name'] ?? 'No name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Email: ${data['email'] ?? 'N/A'}'),
                      Text('Country: ${data['country'] ?? 'N/A'}'),
                      Text('ID: ${data['id'] ?? 'N/A'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
