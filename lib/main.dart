import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/Screens/bottom_navigation_screen.dart';
import 'package:assign_mate/colors.dart';
import 'package:assign_mate/pdf_viewer_demo_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'BaseScreens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => LoginProvider()),
    ],
        child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static String mainUrl = "https://assignmate-backend.onrender.com";

  @override
  Widget build(BuildContext context) {
   return MaterialApp(
     debugShowCheckedModeBanner: false,
     theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: prColor),
     ),
     home: const SplashScreen(),
   );
  }

}

