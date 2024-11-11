import 'dart:async';
import 'package:assign_mate/BaseScreens/login_Screen.dart';
import 'package:flutter/material.dart';
import '../DataClasses/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  _navigateLoginScreen() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  String text = "AssignMate";
  String displayText = "";
  int index = 0;

  @override
  void initState() {
    super.initState();
    _startAnimation();
    _navigateLoginScreen();
  }

  void _startAnimation() {
    Timer.periodic(const Duration(milliseconds: 300), (timer) {
      if (index < text.length) {
        setState(() {
          displayText += text[index];
          index++;
        });
      } else {
        timer.cancel(); // Stop the timer when the animation is complete
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cdColor,
      body: Center(
        child: Text(
          displayText,
          style: const TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: prColor, // You can set your desired color
          ),
        ),
      ),
    );
  }
}
