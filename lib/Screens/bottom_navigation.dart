import 'package:assign_mate/assignment/assignment_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../admin/admin_assignment_screen.dart';
import '../DataClasses/colors.dart';
import 'more_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _currentIndex = 0;
  final List<Widget> _tabs =[
    const AssignmentScreen(),
    const MoreScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        color: prColor,
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.01,
          ),
          child: GNav(
            gap: screenWidth * 0.02, // Adjust gap using screen width
            color: txColor,
            activeColor: txColor,
            tabBackgroundColor: cdColor,
            onTabChange: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            tabs: [
              GButton(
                margin: EdgeInsets.only(left: screenWidth * 0.1),
                icon: Icons.assignment,
                text: 'Assignments',
              ),
              GButton(
                margin: EdgeInsets.only(right: screenWidth * 0.1),
                icon: Icons.more_horiz,
                text: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
