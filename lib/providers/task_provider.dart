import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/local_storage_service.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final LocalStorageService _localStorageService = LocalStorageService();

  List<Task> get tasks => _tasks;

  List<Task> get todayTasks {
    final now = DateTime.now();
    return _tasks.where((task) =>
        task.dueDate.year == now.year &&
        task.dueDate.month == now.month &&
        task.dueDate.day == now.day).toList();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) =>
        task.dueDate.year == date.year &&
        task.dueDate.month == date.month &&
        task.dueDate.day == date.day).toList();
  }

  Future<void> loadTasks() async {
    _tasks = await _localStorageService.loadTasks();
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    await _localStorageService.addTask(task);
    await loadTasks(); // Reload tasks to update the list
  }

  Future<void> updateTask(Task updatedTask) async {
    await _localStorageService.updateTask(updatedTask);
    await loadTasks(); // Reload tasks to update the list
  }

  Future<void> deleteTask(String taskId) async {
    await _localStorageService.deleteTask(taskId);
    await loadTasks(); // Reload tasks to update the list
  }
}
