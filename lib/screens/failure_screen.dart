import 'package:flutter/material.dart';
import 'package:daily_tasks_app/models/task.dart';
import 'package:daily_tasks_app/services/task_service.dart';

class FailureScreen extends StatefulWidget {
  const FailureScreen({super.key});

  @override
  State<FailureScreen> createState() => _FailureScreenState();
}

class _FailureScreenState extends State<FailureScreen> {
  final _taskService = TaskService();

  late List<MapEntry<DateTime, List<Task>>> failedGroups;

  @override
  void initState() {
    super.initState();
    _loadFailedGroups();
  }

  void _loadFailedGroups() {
    failedGroups = _taskService.getFailedTasksGroupedByDate();
  }

  Future<void> _handleTaskUpload(Task task) async {
    final newTask = Task(title: task.title, createdAt: DateTime.now());
    await _taskService.addTask(newTask);
    await _taskService.deleteTask(task);
    setState(() {
      _loadFailedGroups();
    });
  }

  Future<void> _handleDeleteTask(Task task) async {
    await _taskService.deleteTask(task);
    setState(() {
      _loadFailedGroups();
    });
  }

  Future<void> _handleDeleteGroup(DateTime date, List<Task> tasks) async {
    for (final task in tasks) {
      await _taskService.deleteTask(task);
    }
    setState(() {
      _loadFailedGroups();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Filter out empty groups so cards with no tasks are not shown
    final nonEmptyGroups =
        failedGroups.where((entry) => entry.value.isNotEmpty).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      body: ListView.builder(
        itemCount: nonEmptyGroups.length,
        itemBuilder: (context, index) {
          final entry = nonEmptyGroups[index];
          final date = entry.key;
          final tasks = entry.value;
          return Card(
            color: const Color(0xFFE3EDF7), // Soft card color
            margin: const EdgeInsets.all(8),
            child: ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    date.toLocal().toString().split(' ')[0],
                    style: const TextStyle(
                      color: Color(0xFF4A6572),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFB2B2B2)),
                    tooltip: 'Delete all tasks for this date',
                    onPressed: () => _handleDeleteGroup(date, tasks),
                  ),
                ],
              ),
              children: tasks
                  .map((task) => ListTile(
                        title: Text(
                          task.title,
                          style: const TextStyle(color: Color(0xFF4A6572)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.upload,
                                  color: Color(0xFFB2B2B2)),
                              onPressed: () => _handleTaskUpload(task),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color(0xFFB2B2B2)),
                              tooltip: 'Delete this task',
                              onPressed: () => _handleDeleteTask(task),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          );
        },
      ),
    );
  }
}
