import 'package:flutter/material.dart';

class CustomDialog {
  static Future<void> showDialogBox(
    BuildContext context, {
    required String message,
    String title = "Message",
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF919CB6),
          title: Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          content: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
            child: Text(
              message,
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK", style: TextStyle(color: Color(0xFF46639B))),
            ),
          ],
        );
      },
    );
  }
}
