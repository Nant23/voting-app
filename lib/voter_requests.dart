import 'package:flutter/material.dart';
import 'admin/admin_nav.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class VoterRequests extends StatefulWidget {
  final int selectedIndex;

  const VoterRequests({super.key, this.selectedIndex = 1}); // Default to 1

  @override
  _VoterRequestsState createState() => _VoterRequestsState();
}

class _VoterRequestsState extends State<VoterRequests> {

  Stream<DocumentSnapshot<Map<String, dynamic>>?> getSingleUnregisteredUser() {
    return FirebaseFirestore.instance
        .collection('voter_registration')
        .where('status', isEqualTo: 'unregistered')
        .limit(1)
        .snapshots()
        .map((snapshot) => snapshot.docs.isNotEmpty ? snapshot.docs.first : null);
  }

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
      appBar: AppBar(title: Text('Voter Requests')),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>?>(
      stream: getSingleUnregisteredUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final doc = snapshot.data;
        if (doc == null) {
          return Center(child: Text('No unregistered users found.'));
        }

        final data = doc.data()!;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name: ${data['Name']}', style: TextStyle(fontSize: 18)),
                  Text('Age: ${data['Age']}', style: TextStyle(fontSize: 18)),
                  Text('Gender: ${data['Gender']}', style: TextStyle(fontSize: 18)),
                  Text('Phone: ${data['Phone Number']}', style: TextStyle(fontSize: 18)),
                  Text('Country: ${data['Country']}', style: TextStyle(fontSize: 18)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF46639B),
                    ),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('voter_registration')
                          .doc(doc.id)
                          .update({'status': 'registered'});
                    },
                    child: Text('Accept', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF46639B),
                    ),
                    onPressed:() async {
                      await FirebaseFirestore.instance
                          .collection('voter_registration')
                          .doc(doc.id)
                          .update({'status': 'declined'});
                    },
                    child: Text('Reject', style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
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
