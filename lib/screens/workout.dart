// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class WorkoutScreen extends StatelessWidget {
  int _selectedIndex = 1; // Set the initial index to 1 for the Workout screen

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1A32),
        elevation: 0,
        title: const Text(
          'Workout',
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrainingOfTheDayCard(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "Choose your workout plan.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 24),
            // Workout Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildWorkoutCard(
                    'Full Body Workout',
                    '20 Minutes | Beginner',
                    'images/body-stretching.png', // Local asset
                  ),
                  const SizedBox(height: 16),
                  _buildWorkoutCard(
                    'Upper Body Strength',
                    '30 Minutes | Intermediate',
                    'images/upper-body.png', // Local asset
                  ),
                  const SizedBox(height: 16),
                  _buildWorkoutCard(
                    'Lower Body Strength',
                    '45 Minutes | Intermediate',
                    'images/squat.png', // Local asset
                  ),
                  const SizedBox(height: 16),
                  _buildWorkoutCard(
                    'Glutes & Abs',
                    '60 Minutes | Advanced',
                    'images/abs.png', // Local asset
                  ),
                ],
              ),
            ),
          ],
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

  // "Training of the Day" Card Widget
  Widget _buildTrainingOfTheDayCard() {
    return Stack(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: Image.asset(
              'images/fitness.png', // Replace with your local asset path
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Training of the Day',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Squat Exercise',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutCard(String title, String details, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2438),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              imageUrl,
              height: 80,
              width: 80,
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
                Text(
                  details,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}