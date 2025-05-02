import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin/admin_nav.dart';

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
      appBar: AppBar(title: Text('Registered Voters')),
      backgroundColor: const Color(0xFFBED2EE),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('voter_registration')
            .where('status', isEqualTo: 'registered')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final voters = snapshot.data!.docs;

          if (voters.isEmpty) {
            return Center(child: Text('No registered voters found.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: voters.length,
            itemBuilder: (context, index) {
              final data = voters[index].data() as Map<String, dynamic>;

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
                        data['Name'] ?? 'No name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text('Age: ${data['Age'] ?? 'N/A'}'),
                      Text('Gender: ${data['Gender'] ?? 'N/A'}'),
                      Text('Phone: ${data['Phone Number'] ?? 'N/A'}'),
                      Text('Country: ${data['Country'] ?? 'N/A'}'),
                      Text('ID: ${data['id'] ?? 'N/A'}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
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
