import 'package:assign_mate/Providers/login_provider.dart';
import 'package:assign_mate/Providers/user_provider.dart';
import 'package:assign_mate/DataClasses/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'BaseScreens/splash_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zmjmyctermjezbovwyug.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inptam15Y3Rlcm1qZXpib3Z3eXVnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEzMzc2MzcsImV4cCI6MjA0NjkxMzYzN30.M2rME87CuDGSUN5eYQAMsWZA6fTrhii6oFz10q6LQwI',
  );
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (context) => LoginProvider()),
      ChangeNotifierProvider(create: (context) => UserProvider()),
    ],
        child: MyApp(),
    )
  );

}
//https://zmjmyctermjezbovwyug.supabase.co
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

