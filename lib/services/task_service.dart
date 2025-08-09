import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskService {
  final Box<Task> _box = Hive.box<Task>('tasksBox');

  List<Task> getTodayTasks() {
    final now = DateTime.now();
    return _box.values.where((task) =>
      task.createdAt.day == now.day &&
      task.createdAt.month == now.month &&
      task.createdAt.year == now.year
    ).toList();
  }

  List<MapEntry<DateTime, List<Task>>> getFailedTasksGroupedByDate() {
    final now = DateTime.now();
    final failed = _box.values.where((task) =>
      !task.isCompleted &&
      !(task.createdAt.day == now.day && task.createdAt.month == now.month && task.createdAt.year == now.year)
    );

    final Map<String, List<Task>> grouped = {};
    for (var task in failed) {
      final key = DateTime(task.createdAt.year, task.createdAt.month, task.createdAt.day).toIso8601String();
      grouped.putIfAbsent(key, () => []).add(task);
    }
    return grouped.entries.map((e) => MapEntry(DateTime.parse(e.key), e.value)).toList();
  }

  Future<void> addTask(Task task) => _box.add(task);
  Future<void> toggleTask(Task task) async { task.isCompleted = !task.isCompleted; await task.save(); }
  Future<void> deleteTask(Task task) => task.delete();
}