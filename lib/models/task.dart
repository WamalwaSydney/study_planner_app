import 'package:uuid/uuid.dart';

class Task {
  String id;
  String title;
  String? description;
  DateTime dueDate;
  DateTime? reminderTime;
  bool isCompleted;

  Task({
    String? id,
    required this.title,
    this.description,
    required this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        dueDate: DateTime.parse(json["dueDate"]),
        reminderTime: json["reminderTime"] != null
            ? DateTime.parse(json["reminderTime"])
            : null,
        isCompleted: json["isCompleted"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "dueDate": dueDate.toIso8601String(),
        "reminderTime": reminderTime?.toIso8601String(),
        "isCompleted": isCompleted,
      };

  @override
  String toString() {
    return 'Task(id: $id, title: $title, dueDate: $dueDate, isCompleted: $isCompleted)';
  }
}
