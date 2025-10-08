import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final ValueChanged<bool?>? onToggleComplete;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const TaskListItem({
    super.key,
    required this.task,
    this.onToggleComplete,
    this.onEdit,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: onToggleComplete,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description != null && task.description!.isNotEmpty)
              Text(task.description!),
            Text('Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
            if (task.reminderTime != null)
              Text('Reminder: ${DateFormat('HH:mm').format(task.reminderTime!)}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
