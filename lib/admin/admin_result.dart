import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ElectionResultsPage extends StatefulWidget {
  @override
  _ElectionResultsPageState createState() => _ElectionResultsPageState();
}

class _ElectionResultsPageState extends State<ElectionResultsPage> {
  String selectedFilter = 'Past Election';
  final List<String> filterOptions = ['Present Election', 'Past Election'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBED2EE),
      appBar: AppBar(title: Text("Election Viewer")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              items: filterOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontSize: 16)),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedFilter = newValue!;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('questions')
                  .where('status', isEqualTo: selectedFilter == 'Past Election' ? 'Closed' : 'Ongoing')
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

                final polls = snapshot.data!.docs;

                if (polls.isEmpty) {
                  return Center(child: Text('No data available for $selectedFilter'));
                }

                return ListView.builder(
                  itemCount: polls.length,
                  itemBuilder: (context, index) {
                    final doc = polls[index].data() as Map<String, dynamic>;

                    final questionTitle = doc['question'] ?? 'Untitled Poll';

                    // Dynamically extract options and votes
                    final options = <Map<String, dynamic>>[];

                    doc.forEach((key, value) {
                      if (key.startsWith('question ') && key != 'question') {
                        final index = key.split(' ').last;
                        final voteKey = 'q${index}_votes';
                        final votes = doc[voteKey] ?? 0;
                        options.add({
                          'label': value,
                          'votes': votes,
                        });
                      }
                    });

                    // Sort by votes (only for past elections)
                    if (selectedFilter == 'Past Election') {
                      options.sort((a, b) => b['votes'].compareTo(a['votes']));
                    }
                    final winner = options.isNotEmpty ? options.first : null;

                    return Card(
                      margin: EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(questionTitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            ...options.map((opt) => Text(
                              '${opt['label']}: ${opt['votes']} votes',
                              style: TextStyle(
                                fontWeight: selectedFilter == 'Past Election' && opt == winner
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: selectedFilter == 'Past Election' && opt == winner
                                    ? Colors.green
                                    : Colors.black,
                              ),
                            )),
                            if (selectedFilter == 'Past Election' && winner != null) ...[
                              SizedBox(height: 8),
                              Text('Winner: ${winner['label']}',
                                  style: TextStyle(fontSize: 16, color: Colors.blue)),
                            ]
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
