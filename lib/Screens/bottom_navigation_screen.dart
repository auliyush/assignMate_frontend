import 'package:assign_mate/assignment/assignment_screen.dart';
import 'package:assign_mate/Screens/more_screen.dart';
import 'package:assign_mate/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../assignment/create_assignment_screen.dart';

class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {

  int _currentIndex = 0;
  final List<Widget> _tabs =[
   const AssignmentScreen(),
   const CreateAssignmentScreen(),
   const MoreScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        color: prColor,
        child:  Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          child: GNav(
              gap: 8,
              color: txColor,
              activeColor: txColor,
              tabBackgroundColor: cdColor,
              onTabChange: (index){
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
                )
              ]
          ),
        ),
      ),
    );
  }
}