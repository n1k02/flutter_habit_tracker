import 'package:flutter/material.dart';

class MyHabitTile extends StatelessWidget {
  final String text;
  final bool isCompleted;
  final void Function(bool?)? onChanged;

  const MyHabitTile(
      {super.key,
      required this.text,
      required this.isCompleted,
      required this.onChanged
    });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if( onChanged != null) {
          // toggle compl status
          onChanged!(!isCompleted);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green
                : Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: ListTile(
          title: Text(text),
          leading: Checkbox(
            activeColor: Colors.green,
            value: isCompleted,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}
