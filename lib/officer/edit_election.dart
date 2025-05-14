import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditElection extends StatefulWidget {
  final String documentId;
  const EditElection({super.key, required this.documentId});

  @override
  State<EditElection> createState() => _EditElectionState();
}

class _EditElectionState extends State<EditElection> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  Map<String, dynamic>? electionData;

  @override
  void initState() {
    super.initState();
    _fetchElectionData();
  }

  Future<void> _fetchElectionData() async {
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc(widget.documentId)
        .get();

    if (snapshot.exists) {
      setState(() {
        electionData = snapshot.data() as Map<String, dynamic>;
        _questionController.text = electionData?['question'] ?? '';

        int index = 1;
        while (electionData!.containsKey('question $index')) {
          final controller = TextEditingController(text: electionData!['question $index']);
          _optionControllers.add(controller);
          index++;
        }
      });
    }
  }

  Future<void> _saveChanges() async {
    final shouldProceed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Changes'),
        content: const Text('Are you sure you want to save these changes?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF46639B),
            ),
            child: const Text(
              'Yes, Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (shouldProceed != true) return; // User canceled

    // Proceed to update the data in Firestore
    if (electionData == null) return;

    Map<String, dynamic> updatedData = {
      'question': _questionController.text.trim(),
    };

    for (int i = 0; i < _optionControllers.length; i++) {
      updatedData['question ${i + 1}'] = _optionControllers[i].text.trim();
    }

    await FirebaseFirestore.instance
        .collection('questions')
        .doc(widget.documentId)
        .update(updatedData);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Changes saved successfully!')),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Election')),
      backgroundColor: const Color(0xFFBED2EE),
      body: electionData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  TextField(
                    controller: _questionController,
                    decoration: const InputDecoration(
                      labelText: 'Main Question',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ..._optionControllers.asMap().entries.map(
                        (entry) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: TextField(
                            controller: entry.value,
                            decoration: InputDecoration(
                              labelText: 'Option ${entry.key + 1}',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF46639B),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                    ),
                    child: const Text(
                      'Save Changes',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
