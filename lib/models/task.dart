import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Task extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  final DateTime createdAt;

  Task({required this.title, this.isCompleted = false, required this.createdAt});

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}