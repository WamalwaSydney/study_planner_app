import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:study_planner_app/models/task.dart';
import 'package:study_planner_app/providers/task_provider.dart';

class TaskForm extends StatefulWidget {
  final Task? task;

  const TaskForm({super.key, this.task});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  String? _description;
  late DateTime _dueDate;
  DateTime? _reminderTime;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _title = widget.task!.title;
      _description = widget.task!.description;
      _dueDate = widget.task!.dueDate;
      _reminderTime = widget.task!.reminderTime;
    } else {
      _title = '';
      _dueDate = DateTime.now();
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reminderTime ?? DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        _reminderTime = DateTime(
          _dueDate.year,
          _dueDate.month,
          _dueDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      if (widget.task == null) {
        // Add new task
        final newTask = Task(
          title: _title,
          description: _description,
          dueDate: _dueDate,
          reminderTime: _reminderTime,
        );
        taskProvider.addTask(newTask);
      } else {
        // Update existing task
        final updatedTask = widget.task!.copyWith(
          title: _title,
          description: _description,
          dueDate: _dueDate,
          reminderTime: _reminderTime,
        );
        taskProvider.updateTask(updatedTask);
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
              initialValue: widget.task?.title,
              decoration: const InputDecoration(labelText: 'Title'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
              onSaved: (value) {
                _title = value!;
              },
            ),
            TextFormField(
              initialValue: widget.task?.description,
              decoration: const InputDecoration(labelText: 'Description (Optional)'),
              onSaved: (value) {
                _description = value;
              },
            ),
            ListTile(
              title: Text('Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDate(context),
            ),
            ListTile(
              title: Text(
                  'Reminder Time: ${_reminderTime == null ? 'Not set' : DateFormat('HH:mm').format(_reminderTime!)}'),
              trailing: const Icon(Icons.alarm),
              onTap: () => _selectTime(context),
            ),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text(widget.task == null ? 'Add Task' : 'Update Task'),
            ),
          ],
        ),
      ),
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
