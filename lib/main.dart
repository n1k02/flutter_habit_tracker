import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/pages/home_page.dart';
import 'package:flutter_habit_tracker/theme/dark_mode.dart';
import 'package:flutter_habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MainApp())
    );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: darkMode,
    );
  }
}
