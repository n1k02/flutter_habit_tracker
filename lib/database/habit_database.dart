import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/models/app_settings.dart';
import 'package:flutter_habit_tracker/models/habit.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar? isar;

  // steup

  // initialize db
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  // save first date of app startup
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar?.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar?.writeTxn(() => isar!.appSettings.put(settings));
    }
  }

  // get first date of app startup
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar?.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  // crud operations

  // list of habits
  final List<Habit> currentHabits = [];

  //* create
  Future<void> addHabit(String habitName) async {
    // create a new habit
    final newHabit = Habit()..name = habitName;

    // save to db
    await isar?.writeTxn(() => isar!.habits.put(newHabit));

    // re-read from db
    readHabits();
  }

  //* read
  Future<void> readHabits() async {
    // fetch all habits from db
    List<Habit> fetchHabits = await isar!.habits.where().findAll();

    // give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchHabits);

    // update UI
    notifyListeners();
  }

  //* update
  // check habit on / off

  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    // find the habit
    final habit = await isar?.habits.get(id);

    // update completion status
    if (habit != null) {
      await isar?.writeTxn(() async {
        final today = DateTime.now();
        // if habit is completed -> add the current date to the completedDays list
        if (isCompleted && habit.completedDays.contains(DateTime.now())) {
          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }

        // if habit is NOT completed -> remove the current date from the list
        else {
          habit.completedDays.removeWhere((date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        }

        // save the updated habits
        return isar?.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  // edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    // find the specific habit
    final habit = await isar?.habits.get(id);

    // update habit name
    if (habit != null) {
      await isar?.writeTxn(() async {
        habit.name = newName;
        isar?.habits.put(habit);
      });
    }

    // re-read from db
    readHabits();
  }

  //* delete
  Future<void> deleteHabit(int id) async {
    // perform delete
    await isar?.writeTxn(() async {
      return isar?.habits.delete(id);
    });

    // re-read from db
    readHabits();
  }
}
