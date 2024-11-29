import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:growstreak/screens/Ask_ai_screen.dart';
import 'package:growstreak/screens/home_page.dart';
import 'package:growstreak/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AskAiScreen(),
    const ProfileScreen(),
    
  ];

  @override
  Widget build(BuildContext context) {
    // Width of the screen and navigation bar
    final screenWidth = MediaQuery.of(context).size.width;
    final navBarWidth = screenWidth - 40; // Navigation bar width (20 padding on both sides)
    final sectionWidth = navBarWidth / 4; // Width for each tab section

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bgimage.jpg'), // Replace with your background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          // Current Page Content
          _pages[_currentIndex],
          // Glass Navigation Bar
          Positioned(
            bottom: 50, // Adjust to move navigation bar upward
            left: 20,
            right: 20,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Solid Underline Effect
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  left: (_currentIndex * sectionWidth) + (sectionWidth / 2 - 25), // Dynamic position
                  top: -15, // Adjust the position
                  child: Container(
                    width: 50,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.cyanAccent.withOpacity(0.8), // Solid color
                      borderRadius: BorderRadius.circular(10), // Rounded underline
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.5), // Soft shadow
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                // Navigation Bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Glass blur effect
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.white.withOpacity(0.05),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildNavItem(Icons.home, 'Home', 0),
                          _buildNavItem('assets/logoAi.png', 'Ask Ai', 1, isCustomIcon: true),
                          _buildNavItem(Icons.person, 'Profile', 2),
                         
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build navigation items
  Widget _buildNavItem(dynamic icon, String label, int index, {bool isCustomIcon = false}) {
    bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 35,
            height: 35,
            child: isCustomIcon
                ? Image.asset(
                    icon,
                    color: isSelected ? Colors.white : Colors.white70,
                  )
                : Icon(
                    icon,
                    color: isSelected ? Colors.white : Colors.white70,
                    size: 28,
                  ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.white : Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
