import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:hive/hive.dart';
import 'package:daily_tasks_app/models/task.dart';

class HiveExportService {
  Future<String> exportTasksToJsonFile() async {
    final box = Hive.box<Task>('tasksBox');
    final tasks = box.values.map((task) => task.toJson()).toList();
    final jsonString = const JsonEncoder.withIndent('  ').convert(tasks);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/tasks_export.json');
    await file.writeAsString(jsonString);
    return file.path;
  }

  Future<void> shareExportedJson() async {
    final path = await exportTasksToJsonFile();
    await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
  }
}
