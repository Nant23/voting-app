import 'package:flutter/material.dart';

class AddOfficer extends StatefulWidget {
  const AddOfficer({super.key});

  @override
  State<AddOfficer> createState() => _AddOfficerState();
}

class _AddOfficerState extends State<AddOfficer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Add Officer')));
  }
}
