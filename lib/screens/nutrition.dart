// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NutritionScreen extends StatelessWidget {
  int _selectedIndex = 3; // Set the initial index to 3 for the Nutrition screen

  void _onItemTapped(BuildContext context, int index) {
    _selectedIndex = index;
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

  void _showMenuDialog(BuildContext context, String day) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(day.toLowerCase()).doc('menu').get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('$day Menu'),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Breakfast: ${data['breakfast']}'),
                    const SizedBox(height: 8),
                    Text('Lunch: ${data['lunch']}'),
                    const SizedBox(height: 8),
                    Text('Dinner: ${data['dinner']}'),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog(context, 'No menu found for $day.');
      }
    } catch (e) {
      _showErrorDialog(context, 'Failed to load menu: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1A32),
        elevation: 0,
        title: const Text(
          'Nutrition',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushNamed(context, '/home'); // Navigate to home
          },
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Healthy Recipes",
                style: TextStyle(color: Color(0xFFDBF352), fontSize: 16),
              ),
              const SizedBox(height: 24),
              // Horizontal Scroll for Recipes
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildHorizontalCard(
                      'images/salad.png', // Local asset
                      'Protiens Salad',
                      'Eat greens daily',
                      '200 Kcal',
                    ),
                    const SizedBox(width: 16),
                    _buildHorizontalCard(
                      'images/salmon.png', // Local asset
                      'Baked salmon',
                      'Include protiens in your diet',
                      '350 Kcal',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Nutrition Tips",
                style: TextStyle(color: Color(0xFFDBF352), fontSize: 16),
              ),
              const SizedBox(height: 16),
              // Vertical Scroll for Tips
              Column(
                children: [
                  _buildDayCard(context, 'Monday'),
                  const SizedBox(height: 16),
                  _buildDayCard(context, 'Tuesday'),
                  const SizedBox(height: 16),
                  _buildDayCard(context, 'Wednesday'),
                  const SizedBox(height: 16),
                  _buildDayCard(context, 'Thursday'),
                  const SizedBox(height: 16),
                  _buildDayCard(context, 'Friday'),
                  const SizedBox(height: 16),
                  _buildDayCard(context, 'Saturday'),
                  const SizedBox(height: 16),
                  _buildDayCard(context, 'Sunday'),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF1E1A32),
        selectedItemColor: const Color(0xFF000000),
        unselectedItemColor: const Color(0xFF896CFE),
        currentIndex: _selectedIndex,
        onTap: (index) => _onItemTapped(context, index),
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

  Widget _buildHorizontalCard(String imageUrl, String title, String time, String calories) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2438),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.asset(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 14)),
                const SizedBox(height: 4),
                Text('$time | $calories',
                    style: const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(BuildContext context, String day) {
    return GestureDetector(
      onTap: () => _showMenuDialog(context, day),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF2A2438),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.asset(
                'images/$day.png', // Local asset
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      day,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap to see the menu',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}