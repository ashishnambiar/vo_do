import 'package:flutter/material.dart';
import 'package:vo_do/Screens/main_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontSize: 18),
          titleMedium: TextStyle(fontSize: 18),
        ),
      ),
      home: MainScreen(),
    );
  }
}
