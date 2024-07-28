import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/database/habit_database.dart';
import 'package:flutter_habit_tracker/pages/home_page.dart';
import 'package:flutter_habit_tracker/theme/light_mode.dart';
import 'package:flutter_habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init db
  await HabitDatabase.initialize();

  await HabitDatabase().saveFirstLaunchDate();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => HabitDatabase()),
    ChangeNotifierProvider(create: (context) => ThemeProvider())
  ], child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData ?? lightMode,
    );
  }
}
