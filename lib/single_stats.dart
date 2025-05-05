import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class SingleStats extends StatefulWidget {
  final String documentId;

  const SingleStats({required this.documentId, super.key});

  @override
  State<SingleStats> createState() => _SingleStatsState();
}

class _SingleStatsState extends State<SingleStats> {
  String chartType = 'Bar chart'; // default

  Future<Map<String, dynamic>?> fetchQuestionVotes() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .doc(widget.documentId)
        .get();

    if (!docSnapshot.exists) return null;

    final data = docSnapshot.data()!;
    final result = <String, int>{};

    for (var i = 1; i <= 10; i++) {
      final optionKey = 'question $i';
      final voteKey = 'q${i}_votes';

      if (data.containsKey(optionKey) && data.containsKey(voteKey)) {
        result[data[optionKey]] = data[voteKey] ?? 0;
      } else {
        break;
      }
    }

    return {
      'title': data['question'] ?? 'Untitled',
      'votes': result,
      'status': data['status'] ?? 'Closed',
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Question Statistics')),
      backgroundColor: const Color(0xFFBED2EE),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: DropdownButton<String>(
              value: chartType,
              items: const [
                DropdownMenuItem(value: 'Bar chart', child: Text('Bar chart')),
                DropdownMenuItem(value: 'Pie chart', child: Text('Pie chart')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => chartType = value);
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: fetchQuestionVotes(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return const Center(child: Text('No data found.'));
                }

                final data = snapshot.data!;
                final title = data['title'] as String;
                final votes = data['votes'] as Map<String, int>;
                final status = data['status'] as String;

                final barGroups =
                    votes.entries.toList().asMap().entries.map((entry) {
                  final i = entry.key;
                  final vote = entry.value;
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                          toY: vote.value.toDouble(), color: Colors.blue),
                    ],
                    showingTooltipIndicators: [0],
                  );
                }).toList();

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (status == 'Ongoing')
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text('Ongoing',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              )),
                        ),
                      Text(title,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                              if (status == 'Ongoing')
                                BoxShadow(
                                  color: const Color.fromARGB(255, 43, 149, 43),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                            ],
                          ),
                          child: chartType == 'Bar chart'
                              ? BarChart(
                                  BarChartData(
                                    alignment: BarChartAlignment.spaceAround,
                                    maxY: getMaxY(votes),
                                    barTouchData: BarTouchData(enabled: true),
                                    titlesData: FlTitlesData(
                                      bottomTitles: AxisTitles(
                                        sideTitles: SideTitles(
                                          showTitles: true,
                                          getTitlesWidget: (value, meta) {
                                            final index = value.toInt();
                                            final labels = votes.keys.toList();
                                            final label =
                                                (index < labels.length)
                                                    ? labels[index]
                                                    : '';

                                            return SideTitleWidget(
                                              meta: meta,
                                              space: 8.0,
                                              child: Transform.rotate(
                                                angle: -0.5,
                                                child: Text(
                                                  label,
                                                  style: const TextStyle(
                                                      fontSize: 10),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      leftTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      topTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                      rightTitles: AxisTitles(
                                          sideTitles:
                                              SideTitles(showTitles: false)),
                                    ),
                                    gridData: FlGridData(show: true),
                                    borderData: FlBorderData(show: false),
                                    barGroups: barGroups,
                                  ),
                                )
                              : PieChart(
                                  PieChartData(
                                    sections: votes.entries.map((entry) {
                                      return PieChartSectionData(
                                        value: entry.value.toDouble(),
                                        title: entry.key,
                                        color: Colors.primaries[votes.keys
                                                .toList()
                                                .indexOf(entry.key) %
                                            Colors.primaries.length],
                                        titleStyle: const TextStyle(
                                            fontSize: 12, color: Colors.white),
                                      );
                                    }).toList(),
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

double getMaxY(Map<String, int> votes) {
  if (votes.isEmpty) return 5;
  final max = votes.values.reduce((a, b) => a > b ? a : b);
  return (max + 5).toDouble();
}
