import 'package:daily_tasks_app/screens/failure_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../services/hive_export_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _taskService = TaskService();
  final _exportService = HiveExportService();

  int _selectedIndex = 0;

  void _addTask(String title) async {
    final task = Task(title: title, createdAt: DateTime.now());
    await _taskService.addTask(task);
    setState(() {});
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _taskService.getTodayTasks();
    final now = DateTime.now();
    final formattedDate = DateFormat('EEEE, dd MMMM yyyy').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft background
      appBar: AppBar(
        backgroundColor: const Color(0xFFE3EDF7), // Soft AppBar color
        elevation: 0,
        title: Text(
          _selectedIndex == 0 ? 'Today\'s Tasks' : 'Past Tasks',
          style: const TextStyle(
            color: Color(0xFF4A6572), // Soft text color
          ),
        ),
        iconTheme: const IconThemeData(color: Color(0xFF4A6572)),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.share, color: Color(0xFF4A6572)),
              onPressed: () => _exportService.shareExportedJson(),
            ),
        ],
      ),
      body: _selectedIndex == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    formattedDate,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A6572), // Soft text color
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        color: const Color(0xFFE3EDF7), // Soft card color
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(
                            task.title,
                            style: const TextStyle(color: Color(0xFF4A6572)),
                          ),
                          leading: Checkbox(
                            value: task.isCompleted,
                            activeColor: const Color(0xFFB2DFDB), // Soft accent
                            onChanged: (_) async {
                              await _taskService.toggleTask(task);
                              setState(() {});
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete,
                                color: Color(0xFFB2B2B2)),
                            onPressed: () async {
                              await _taskService.deleteTask(task);
                              setState(() {});
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )
          : const FailureScreen(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              backgroundColor: const Color(0xFFB2DFDB), // Soft accent
              child: const Icon(Icons.add, color: Color(0xFF4A6572)),
              onPressed: () async {
                final controller = TextEditingController();
                await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: const Color(0xFFE3EDF7),
                    title: const Text('New Task',
                        style: TextStyle(color: Color(0xFF4A6572))),
                    content: TextField(controller: controller),
                    actions: [
                      TextButton(
                        onPressed: () {
                          _addTask(controller.text);
                          Navigator.pop(context);
                        },
                        child: const Text('Add',
                            style: TextStyle(color: Color(0xFF4A6572))),
                      ),
                    ],
                  ),
                );
              },
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavBarTap,
        backgroundColor: const Color(0xFFE3EDF7),
        selectedItemColor: const Color(0xFF4A6572),
        unselectedItemColor: const Color(0xFFB2B2B2),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
        ],
      ),
    );
  }
}
