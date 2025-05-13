import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

Future<bool> isUserRegistered(String uid) async {
  try {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('voter_registration')
        .doc(uid)
        .get();

    if (!doc.exists) return false;
    var data = doc.data() as Map<String, dynamic>;
    return data['status'] == 'registered';
  } catch (e) {
    print('Error checking registration status: $e');
    return false;
  }
}
