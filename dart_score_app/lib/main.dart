import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'providers/game_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: const DartScoringApp(),
    ),
  );
}

class DartScoringApp extends StatelessWidget {
  const DartScoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dart Scoring MVP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1E1E1E),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.bold, color: Colors.white),
          headlineMedium: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.white70),
          bodyMedium: TextStyle(fontSize: 14.0, color: Colors.white60),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
