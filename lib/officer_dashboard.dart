import 'package:flutter/material.dart';

class Officer extends StatefulWidget {
  const Officer({super.key});

  @override
  State<Officer> createState() => _OfficerState();
}

class _OfficerState extends State<Officer> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Officer Dashboardddddddd')
      )
    );
  }
}