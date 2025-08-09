import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:daily_tasks_app/models/task.dart';
import 'package:daily_tasks_app/screens/home_screen.dart';
import 'package:daily_tasks_app/screens/failure_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await Hive.openBox<Task>('tasksBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Tasks',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/failures': (context) => const FailureScreen(),
      },
    );
  }
}
