import 'package:assign_mate/admin/admin_more_screen.dart';
import 'package:assign_mate/admin/admin_assignment_screen.dart';
import 'package:assign_mate/Screens/more_screen.dart';
import 'package:assign_mate/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'create_assignment_screen.dart';

class AdminBottomNavigation extends StatefulWidget {
  const AdminBottomNavigation({super.key});

  @override
  State<AdminBottomNavigation> createState() => _AdminBottomNavigationState();
}

class _AdminBottomNavigationState extends State<AdminBottomNavigation> {

  int _currentIndex = 0;
  final List<Widget> _tabs =[
   const AdminAssignmentScreen(),
   const CreateAssignmentScreen(),
   const AdminMoreScreen(),
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
            tabs: const [
              GButton(
                icon: Icons.assignment,
                text: 'Assignment',
              ),
              GButton(
                icon: Icons.add_box,
                text: 'Create Assignment',
              ),
              GButton(
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