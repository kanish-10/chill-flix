import 'package:ChillFlix/screens/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MoviesAndChillApp());
}

class MoviesAndChillApp extends StatelessWidget {
  const MoviesAndChillApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shows and Chill',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
