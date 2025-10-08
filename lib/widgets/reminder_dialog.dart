import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/models/task.dart';

class ReminderDialog extends StatelessWidget {
  final Task task;

  const ReminderDialog({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Task Reminder!'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Title: ${task.title}'),
            if (task.description != null && task.description!.isNotEmpty)
              Text('Description: ${task.description}'),
            Text('Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
            if (task.reminderTime != null)
              Text('Time: ${DateFormat('HH:mm').format(task.reminderTime!)}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Mark as Complete'),
          onPressed: () {
            // This action should be handled by the calling screen/provider
            Navigator.of(context).pop(true);
          },
        ),
        TextButton(
          child: const Text('Later'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
