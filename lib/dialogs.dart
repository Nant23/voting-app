import 'package:flutter/material.dart';

class Dialog {
  static Future<void> successDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF919CB6),
          content: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Text(
              "Successfully logged in.",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(color: Color(0xFFAF6666))),
            ),
          ],
        );
      },
    );
  }
}
