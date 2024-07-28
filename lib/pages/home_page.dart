import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/components/my_drawer.dart';
import 'package:flutter_habit_tracker/database/habit_database.dart';
import 'package:flutter_habit_tracker/models/habit.dart';
import 'package:flutter_habit_tracker/theme/theme_provider.dart';
import 'package:flutter_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // read existing habits on app startup
    Provider.of<HabitDatabase>(context, listen: false).readHabits();
    super.initState();
  }

  // text controller
  final TextEditingController textController = TextEditingController();

  // create new habit
  void createNewHabit() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: textController,
                decoration: InputDecoration(hintText: 'Create a new habit'),
              ),
              actions: [
                // save
                MaterialButton(
                  onPressed: () {
                    String newHabitName = textController.text;
                    context.read<HabitDatabase>().addHabit(newHabitName);
                    Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text('Save'),
                ),

                // cancel
                MaterialButton(
                  onPressed: () {
                    // pop box
                    Navigator.pop(context);
                    textController.clear();
                  },
                  child: const Text('Cancel'),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: const Text('Test App'),
          ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: Icon(Icons.add,
            color: Theme.of(context).colorScheme.inversePrimary),
      ),
      body: _buildHabitList(),
    );
  }

  Widget _buildHabitList() {
    // habit db
    final habitDatabase = context.watch<HabitDatabase>();

    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    // return list of habits UI
    if (currentHabits.isEmpty) {
      return ListTile(title: Text('No habits'));
    }

    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        // Get habit
        final habit = currentHabits[index];

        // Check if habit is completed
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);

        // Return habit tile UI
        return ListTile(
          title: Text(habit.name),
          trailing: isCompletedToday ? Icon(Icons.check) : null,
        );
      },
    );
  }
}
