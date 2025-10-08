import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class LocalStorageService {
  static const String _tasksKey = 'tasks';
  static const String _storageMethodKey = 'storageMethod';

  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_tasksKey);
    if (tasksString == null) {
      return [];
    }
    final List<dynamic> taskListJson = json.decode(tasksString);
    return taskListJson.map((json) => Task.fromJson(json)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String tasksString = json.encode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksString);
  }

  Future<void> addTask(Task task) async {
    List<Task> tasks = await loadTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task updatedTask) async {
    List<Task> tasks = await loadTasks();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String taskId) async {
    List<Task> tasks = await loadTasks();
    tasks.removeWhere((task) => task.id == taskId);
    await saveTasks(tasks);
  }

  Future<String> getStorageMethod() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_storageMethodKey) ?? 'shared_preferences';
  }

  Future<void> setStorageMethod(String method) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageMethodKey, method);
  }
}
