import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:study_planner_app/providers/task_provider.dart';
import 'package:study_planner_app/providers/settings_provider.dart';
import 'package:study_planner_app/widgets/task_list_item.dart';
import 'package:study_planner_app/widgets/task_form.dart';
import 'package:study_planner_app/widgets/reminder_dialog.dart';
import 'package:study_planner_app/models/task.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  @override
  void initState() {
    super.initState();
    // Delay checking for reminders until after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForReminders();
    });
  }

  void _checkForReminders() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    if (!settingsProvider.remindersEnabled) {
      return; // Reminders are disabled
    }

    final now = DateTime.now();
    for (var task in taskProvider.todayTasks) {
      if (task.reminderTime != null &&
          !task.isCompleted &&
          task.reminderTime!.isBefore(now) &&
          task.reminderTime!.add(const Duration(minutes: 5)).isAfter(now) // Show reminder for tasks due in the last 5 minutes
      ) {
        _showReminderDialog(task);
        break; // Show only one reminder at a time for simplicity
      }
    }
  }

  void _showReminderDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReminderDialog(task: task);
      },
    ).then((result) {
      if (result == true) {
        // User chose to mark as complete
        Provider.of<TaskProvider>(context, listen: false)
            .updateTask(task.copyWith(isCompleted: true));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Tasks'),
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final todayTasks = taskProvider.todayTasks;
          if (todayTasks.isEmpty) {
            return const Center(
              child: Text('No tasks for today!'),
            );
          }
          return ListView.builder(
            itemCount: todayTasks.length,
            itemBuilder: (context, index) {
              final task = todayTasks[index];
              return TaskListItem(
                task: task,
                onToggleComplete: (value) {
                  taskProvider.updateTask(task.copyWith(isCompleted: value));
                },
                onEdit: () {
                  _showTaskForm(context, task: task);
                },
                onDelete: () {
                  taskProvider.deleteTask(task.id);
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showTaskForm(BuildContext context, {Task? task}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: TaskForm(task: task),
        );
      },
    );
  }
}

extension on Task {
  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    DateTime? reminderTime,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      reminderTime: reminderTime ?? this.reminderTime,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
