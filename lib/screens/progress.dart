import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import 'package:cloud_firestore/cloud_firestore.dart'; // Import for Firebase

class ProgressTrackingScreen extends StatefulWidget {
  @override
  _ProgressTrackingScreenState createState() => _ProgressTrackingScreenState();
}

class _ProgressTrackingScreenState extends State<ProgressTrackingScreen> {
  bool showWorkoutLog = true;
  int _selectedIndex = 2; // Set the initial index to 2 for the Progress screen

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home');
        break;
      case 1:
        Navigator.pushNamed(context, '/workout');
        break;
      case 2:
        Navigator.pushNamed(context, '/progress');
        break;
      case 3:
        Navigator.pushNamed(context, '/nutrition');
        break;
      case 4:
        Navigator.pushNamed(context, '/map');
        break;
    }
  }

  void _showAddActivityDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Activity'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: _durationController,
                  decoration: const InputDecoration(labelText: 'Duration (mins)'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(labelText: 'Date (yyyy-MM-dd)'),
                  keyboardType: TextInputType.datetime,
                ),
                TextField(
                  controller: _caloriesController,
                  decoration: const InputDecoration(labelText: 'Calories (Kcal)'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Add'),
              onPressed: () {
                _addActivity();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addActivity() async {
    CollectionReference collRef = FirebaseFirestore.instance.collection('progress');
    await collRef.add({
      'title': _titleController.text,
      'duration': _durationController.text,
      'date': _dateController.text,
      'calories': _caloriesController.text,
    });

    _titleController.clear();
    _durationController.clear();
    _dateController.clear();
    _caloriesController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1A32),
        elevation: 0,
        title: const Text(
          'Progress Tracking',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/home'); // Navigate to home
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.search, color: Colors.white), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications, color: Colors.white), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              // Profile Section
              Row(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('images/profile.png'),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Alina',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Age: 28',
                        style: TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.fitness_center, color: Colors.yellow, size: 18),
                          SizedBox(width: 4),
                          Text('55 Kg Weight', style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.height, color: Colors.yellow, size: 18),
                          SizedBox(width: 4),
                          Text('165 CM Height', style: TextStyle(color: Colors.white54)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Workout Log and Charts Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildTabButton('Workout Log', isSelected: showWorkoutLog, onTap: () {
                    setState(() {
                      showWorkoutLog = true;
                    });
                  }),
                  _buildTabButton('Charts', isSelected: !showWorkoutLog, onTap: () {
                    setState(() {
                      showWorkoutLog = false;
                    });
                  }),
                ],
              ),
              const SizedBox(height: 24),
              if (showWorkoutLog) ...[
                // Date Picker
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Current Date',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildDatePicker(),
                const SizedBox(height: 24),
                // Activities Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Activities',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance.collection('progress').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return CircularProgressIndicator();
                    }
                    return Column(
                      children: snapshot.data!.docs.map((doc) {
                        return Column(
                          children: [
                            _buildActivityCard(
                              title: doc['title'],
                              calories: '${doc['calories']} Kcal',
                              duration: '${doc['duration']} Mins',
                              date: doc['date'],
                              imageUrl: 'images/gym.png', // Replace with appropriate image URL if needed
                            ),
                            const SizedBox(height: 16), // Add space between cards
                          ],
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 24),
              ] else ...[
                // Chart Section
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Progress Chart',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 245, 233, 74),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildLineChart(),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddActivityDialog,
        backgroundColor: const Color.fromARGB(255, 245, 233, 74),
        child: const Icon(Icons.add, color: Colors.black),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1A32),
        selectedItemColor: const Color(0xFF000000),
        unselectedItemColor: const Color(0xFF896CFE),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: 'Workout'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Progress'),
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), label: 'Nutrition'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, {required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.purpleAccent : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.purpleAccent),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    DateTime now = DateTime.now();
    int currentDay = now.day;
    String currentMonth = DateFormat.MMMM().format(now); // Get current month

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(currentMonth, style: TextStyle(color: Colors.white, fontSize: 16)), // Display current month
            Icon(Icons.arrow_drop_down, color: Colors.white),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF2A2438),
            borderRadius: BorderRadius.circular(16),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: 30,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              bool isSelected = index + 1 == currentDay; // Highlight the current day
              return Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.purpleAccent : Colors.transparent,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String calories,
    required String duration,
    required String date,
    required String imageUrl,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2438),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department, color: Colors.yellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          calories,
                          style: const TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.yellow, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          duration,
                          style: const TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  date,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart() {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            border: const Border(
              left: BorderSide(color: Colors.white54, width: 1),
              bottom: BorderSide(color: Colors.white54, width: 1),
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toString(),
                  style: const TextStyle(color: Colors.white54, fontSize: 10),
                ),
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 1.5),
                FlSpot(2, 1.8),
                FlSpot(3, 2),
                FlSpot(4, 2.5),
                FlSpot(5, 3),
              ],
              isCurved: true,
              color: Colors.purpleAccent,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}