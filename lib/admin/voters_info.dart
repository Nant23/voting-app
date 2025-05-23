import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_nav.dart';

class VotersInfoPage extends StatefulWidget {
  final int selectedIndex;

  const VotersInfoPage({this.selectedIndex = 2, super.key});

  @override
  _VotersInfoPageState createState() => _VotersInfoPageState();
}

class _VotersInfoPageState extends State<VotersInfoPage> {
  late int _selectedIndex;
  int? _longPressedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }

  void _confirmAndRemove(DocumentSnapshot voterDoc) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Removal"),
        content: Text("Are you sure you want to remove this voter?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text("Yes, Remove"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection('voter_registration')
          .doc(voterDoc.id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Voter removed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registered Voters'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Image.network(
              "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
              height: 60,
              width: 60,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
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
              final voterDoc = voters[index];
              final data = voterDoc.data() as Map<String, dynamic>;

              return GestureDetector(
                onLongPress: () {
                  setState(() {
                    _longPressedIndex = index;
                  });
                },
                child: Card(
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
                        Text('Email: ${data['Email'] ?? 'N/A'}'),
                        Text('Age: ${data['Age'] ?? 'N/A'}'),
                        Text('Gender: ${data['Gender'] ?? 'N/A'}'),
                        Text('Phone: ${data['Phone Number'] ?? 'N/A'}'),
                        Text('Country: ${data['Country'] ?? 'N/A'}'),
                        Text('ID: ${data['id'] ?? 'N/A'}'),
                        if (_longPressedIndex == index)
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => _confirmAndRemove(voterDoc),
                              icon: Icon(Icons.delete, color: Colors.red),
                              label: Text(
                                "Remove",
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                      ],
                    ),
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

