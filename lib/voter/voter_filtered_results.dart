import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class VoterStatistics extends StatefulWidget {
  const VoterStatistics({super.key});

  @override
  State<VoterStatistics> createState() => _VoterStatisticsState();
}

class _VoterStatisticsState extends State<VoterStatistics> {
  String selectedView = 'Gender';

  Future<List<Map<String, dynamic>>>
      fetchPublishedQuestionsWithDemographics() async {
    final questionSnapshot = await FirebaseFirestore.instance
        .collection('questions')
        .where('publish_status', isEqualTo: 'Published')
        .get();

    final voterSnapshot =
        await FirebaseFirestore.instance.collection('voter_registration').get();

    final voterMap = {
      for (var doc in voterSnapshot.docs)
        doc.data()['id']: {
          'gender': (doc.data()['Gender'] ?? '').toString().toLowerCase(),
          'age': int.tryParse(doc.data()['Age'].toString()) ?? 0,
        }
    };

    return questionSnapshot.docs.map((doc) {
      final data = doc.data();
      final votedUsers = List<String>.from(data['votedUsers'] ?? []);
      final demographics = votedUsers
          .map((uid) => voterMap[uid])
          .where((d) => d != null)
          .cast<Map<String, dynamic>>()
          .toList();

      return {
        'question': data['question'],
        'demographics': demographics,
      };
    }).toList();
  }

  Map<String, int> getGenderDistribution(List<Map<String, dynamic>> data) {
    final counts = <String, int>{};
    for (var entry in data) {
      final gender = entry['gender'];
      counts[gender] = (counts[gender] ?? 0) + 1;
    }
    return counts;
  }

  Map<String, int> getAgeDistribution(List<Map<String, dynamic>> data) {
    final buckets = <String, int>{};
    for (var entry in data) {
      final age = entry['age'];
      String range;
      if (age < 18) {
        range = '<18';
      } else if (age <= 25) {
        range = '18-25';
      } else if (age <= 35) {
        range = '26-35';
      } else if (age <= 50) {
        range = '36-50';
      } else {
        range = '50+';
      }
      buckets[range] = (buckets[range] ?? 0) + 1;
    }
    return buckets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voter Statistics')),
      backgroundColor: const Color(0xFFBED2EE),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButton<String>(
              value: selectedView,
              items: const [
                DropdownMenuItem(value: 'Gender', child: Text('Gender')),
                DropdownMenuItem(value: 'Age', child: Text('Age')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => selectedView = value);
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchPublishedQuestionsWithDemographics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final questionDataList = snapshot.data!;
                if (questionDataList.isEmpty) {
                  return const Center(child: Text('No published questions.'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: questionDataList.length,
                  itemBuilder: (context, index) {
                    final questionData = questionDataList[index];
                    final question = questionData['question'];
                    final demographics = questionData['demographics']
                        as List<Map<String, dynamic>>;

                    if (selectedView == 'Gender') {
                      final genderData = getGenderDistribution(demographics);
                      final total = genderData.values.fold(0, (a, b) => a + b);
                      final sections = genderData.entries.map((e) {
                        final percentage = e.value / total;
                        return PieChartSectionData(
                          value: e.value.toDouble(),
                          title: '${(percentage * 100).toStringAsFixed(1)}%',
                          color: e.key == 'male' ? Colors.blue : Colors.pink,
                          radius: 80,
                          titleStyle: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        );
                      }).toList();

                      return _buildCard(
                        title: 'Gender Distribution\n\nQuestion: $question',
                        child: PieChart(PieChartData(sections: sections)),
                      );
                    } else {
                      final ageData = getAgeDistribution(demographics);

                      // 🔧 Sort age groups by logical order
                      final ageOrder = [
                        '<18',
                        '18-25',
                        '26-35',
                        '36-50',
                        '50+'
                      ];
                      final sortedAgeEntries = ageOrder
                          .where((key) => ageData.containsKey(key))
                          .map((key) => MapEntry(key, ageData[key]!))
                          .toList();

                      final barGroups =
                          sortedAgeEntries.asMap().entries.map((entry) {
                        final index = entry.key;
                        final label = entry.value.key;
                        final count = entry.value.value;
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                                toY: count.toDouble(), color: Colors.green),
                          ],
                          showingTooltipIndicators: [0],
                        );
                      }).toList();

                      return _buildCard(
                        title: 'Age Distribution\n\nQuestion: $question',
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: ageData.values.isEmpty
                                ? 5
                                : ageData.values
                                        .reduce((a, b) => a > b ? a : b)
                                        .toDouble() +
                                    5,
                            barTouchData: BarTouchData(enabled: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    final index = value.toInt();
                                    final labels = sortedAgeEntries
                                        .map((e) => e.key)
                                        .toList();
                                    final label = (index < labels.length)
                                        ? labels[index]
                                        : '';
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      space: 8.0,
                                      child: Transform.rotate(
                                        angle: -0.4,
                                        child: Text(
                                          label,
                                          style: const TextStyle(fontSize: 10),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              leftTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              topTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                              rightTitles: AxisTitles(
                                  sideTitles: SideTitles(showTitles: false)),
                            ),
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            barGroups: barGroups,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: child,
          ),
        ],
      ),
    );
  }
}
