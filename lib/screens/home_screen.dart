import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'sign_in_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;

  void signOut(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignInScreen()),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1A32),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1A32),
        elevation: 0,
        title: const Text(
          'Hi, Alina',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
            icon: const Icon(Icons.fitness_center, color: Colors.white),
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => signOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "It's time to challenge your limits.",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 24),
              // Top Menu
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/workout');
                      },
                      child: _buildMenuItem(Icons.fitness_center, 'Workout'),
                    ),
                    const SizedBox(width: 16), // Add gap between items

                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/progress');
                      },
                      child: _buildMenuItem(Icons.bar_chart, 'Progress Tracking'),
                    ),
                    const SizedBox(width: 16), // Add gap between items
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/nutrition');
                      },
                      child: _buildMenuItem(Icons.fastfood, 'Nutrition'),
                    ),
                    const SizedBox(width: 16), // Add gap between items
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/map');
                      },
                      child: _buildMenuItem(Icons.map, 'Map'),
                    ),
                    const SizedBox(width: 16), // Add gap between items
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Recommendations Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recommendations',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'See All',
                      style: TextStyle(color: Color(0xFF896CFE)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildRecommendationCard(
                      'Squat Exercise',
                      '12 Minutes',
                      '120 Kcal',
                      'images/squat-exercise.png', // Local asset
                    ),
                    const SizedBox(width: 16),
                    _buildRecommendationCard(
                      'Full Body Stretching',
                      '12 Minutes',
                      '120 Kcal',
                      'images/full-body-stretching.png', // Local asset
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Weekly Challenge Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF896CFE),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Weekly Challenge',
                            style: TextStyle(
                              color: Color(0xFFE2F163),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Plank With Hip Twist',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'images/plank-twist.png', // Local asset
                        height: 100,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Articles & Tips Section
              const Text(
                'Articles & Tips',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildArticleCard(
                      'Supplement Guide',
                      'images/supplement.png', // Local asset
                    ),
                    const SizedBox(width: 16),
                    _buildArticleCard(
                      'Effective Daily Routines...',
                      'images/daily-routine.png', // Local asset
                    ),
                  ],
                ),
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

  Widget _buildMenuItem(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: const Color(0xFFE2F163), // Set background color to red
          child: Icon(icon, color: Colors.black), // Set icon color to white
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
      ],
    );
  }

  Widget _buildRecommendationCard(
      String title, String duration, String calories, String imageUrl) {
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
              height: 80,
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
                Text('$duration | $calories',
                    style:
                        const TextStyle(color: Colors.white54, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticleCard(String title, String imageUrl) {
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
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 14)),
          ),
        ],
      ),
    );
  }
}