import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'components/my_textfield.dart';
import 'voting_home_page.dart';
import 'utilities.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _controllers = List.generate(5, (_) => TextEditingController());
  final _errorMessages = List<String?>.filled(5, null);
  bool _showSuccessMessage = false;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  bool _validateFields() {
    bool valid = true;
    List<String> labels = ['Name', 'Age', 'Gender', 'Phone Number', 'Country'];

    for (int i = 0; i < _controllers.length; i++) {
      final text = _controllers[i].text.trim();
      if (text.isEmpty) {
        _errorMessages[i] = '${labels[i]} is required';
        valid = false;
      } else {
        _errorMessages[i] = null;
        if (i == 1) {
          final age = int.tryParse(text);
          if (age == null || age < 18) {
            _errorMessages[i] =
                age == null ? 'Invalid age format' : 'Must be 18 or older';
            valid = false;
          }
        }
      }
    }
    setState(() {});
    return valid;
  }

  Future<void> _submitToFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final uid = user.uid;
    final docRef =
        FirebaseFirestore.instance.collection('voter_registration').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have already registered.'),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.only(bottom: 20, left: 16, right: 16),
        ),
      );
      return;
    }

    final data = {
      'id': uid,
      'Name': _controllers[0].text.trim(),
      'Age': _controllers[1].text.trim(),
      'Gender': _controllers[2].text.trim(),
      'Phone Number': _controllers[3].text.trim(),
      'Country': _controllers[4].text.trim(),
      'status': 'unregistered',
    };

    await docRef.set(data);

    setState(() {
      _showSuccessMessage = true;
      for (final controller in _controllers) {
        controller.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFB3C3D9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, size: 28),
                  color: Colors.black,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: AbsorbPointer(
                  absorbing: _showSuccessMessage,
                  child: Opacity(
                    opacity: _showSuccessMessage ? 0.6 : 1,
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(
                          _controllers.length,
                          (i) => _buildTextField(i),
                        )
                          ..addAll([
                            const SizedBox(height: 24),
                            _dashboardButton(
                              'Register',
                              56,
                              32,
                              0xFF3F527F,
                              _showSuccessMessage
                                  ? null
                                  : () async {
                                      if (_validateFields()) {
                                        await _submitToFirestore();
                                      }
                                    },
                            ),
                          ]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (_showSuccessMessage) _successOverlay(),
        ],
      ),
    );
  }

  Widget _buildTextField(int i) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      MyTextfield(
        controller: _controllers[i],
        hintText: ['Name', 'Age', 'Gender', 'Phone Number', 'Country'][i],
        obscureText: false,
      ),
      if (_errorMessages[i] != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _errorMessages[i]!,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      const SizedBox(height: 12),
    ],
  );

  Widget _successOverlay() => Positioned(
    top: 60,
    left: 0,
    right: 0,
    child: Center(
      child: Container(
        width: 192,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF7F8AA3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Expanded(
              child: Text(
                'Successfully\nRegistered',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  height: 1.2,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(Icons.close, color: Colors.black, size: 20),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _dashboardButton(String text, double height, double fontSize,
      int color, VoidCallback? onTap) =>
      SizedBox(
        width: double.infinity,
        height: height,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(color),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      );
}
