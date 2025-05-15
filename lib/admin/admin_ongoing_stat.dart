import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:voting_app/admin/admin_nav.dart';

class AdminOngoingStat extends StatefulWidget {
  final int selectedIndex;

  AdminOngoingStat({this.selectedIndex = 0});

  @override
  State<AdminOngoingStat> createState() => _AdminOngoingStatState();
}

class _AdminOngoingStatState extends State<AdminOngoingStat> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex;
  }
  String selectedView = 'Gender'; // Default chart view

  Future<List<String>> fetchVotedUsersOfOngoingQuestion() async {
    final query = await FirebaseFirestore.instance
        .collection('questions')
        .where('status', isEqualTo: 'Ongoing')
        .limit(1)
        .get();

    if (query.docs.isEmpty) return [];

    return List<String>.from(query.docs.first.data()['votedUsers'] ?? []);
  }

  Future<List<Map<String, dynamic>>> fetchUserDemographics() async {
    final votedUIDs = await fetchVotedUsersOfOngoingQuestion();
    final votersSnapshot = await FirebaseFirestore.instance
        .collection('voter_registration')
        .get();

    final filteredData = <Map<String, dynamic>>[];

    for (var doc in votersSnapshot.docs) {
      final data = doc.data();
      if (votedUIDs.contains(data['id'])) {
        filteredData.add({
          'gender': (data['Gender'] ?? '').toString().toLowerCase(),
          'age': int.tryParse(data['Age'].toString()) ?? 0,
        });
      }
    }

    return filteredData;
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
      appBar: AppBar(
  title: Text('Voter Statistics'),
  actions: [
    Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Image.network(
        "https://res.cloudinary.com/dmtsrrnid/image/upload/v1747203958/app_logo_vm9amj.png",
        height: 60, // Adjust size as needed
        width: 60,
        fit: BoxFit.contain,
      ),
    ),
  ],
),
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
              future: fetchUserDemographics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final demographics = snapshot.data!;
                if (selectedView == 'Gender') {
                  final genderData = getGenderDistribution(demographics);
                  final sections = genderData.entries.map((e) {
                    final percentage = e.value / genderData.values.reduce((a, b) => a + b);
                    return PieChartSectionData(
                      value: e.value.toDouble(),
                      title: '${(percentage * 100).toStringAsFixed(1)}%',
                      color: e.key == 'male' ? Colors.blue : Colors.pink,
                      radius: 80,
                      titleStyle: const TextStyle(fontSize: 14, color: Colors.white),
                    );
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Gender Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: PieChart(PieChartData(sections: sections)),
                        ),
                      ],
                    ),
                  );
                } else {
                  final ageData = getAgeDistribution(demographics);
                  // Define the desired age range order
                  final sortedAgeRanges = ['<18', '18-25', '26-35', '36-50', '50+'];
                  
                  // Sort the ageData according to the desired order
                  final sortedEntries = sortedAgeRanges
                      .where((key) => ageData.containsKey(key))
                      .map((key) => MapEntry(key, ageData[key]!))
                      .toList();

                  // Create bar groups based on sorted age ranges
                  final barGroups = sortedEntries.asMap().entries.map((entry) {
                    final index = entry.key;
                    //final label = entry.value.key;
                    final count = entry.value.value;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(toY: count.toDouble(), color: Colors.green),
                      ],
                      showingTooltipIndicators: [0],
                    );
                  }).toList();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text('Age Distribution', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: ageData.values.isEmpty ? 5 : ageData.values.reduce((a, b) => a > b ? a : b).toDouble() + 5,
                              barTouchData: BarTouchData(enabled: true),
                              titlesData: FlTitlesData(
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final index = value.toInt();
                                      //final labels = ageData.keys.toList();
                                      final label = (index < sortedEntries.length) ? sortedEntries[index].key : '';
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
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              gridData: FlGridData(show: true),
                              borderData: FlBorderData(show: false),
                              barGroups: barGroups,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update the selected index
          });
        },
      ),
    );
  }
}
