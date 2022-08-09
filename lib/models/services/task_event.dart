import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'task_event.g.dart';

enum TaskEventType { downloadService, downloadFileStatus }

@JsonSerializable(fieldRename: FieldRename.snake)
class TaskEvent {
  const TaskEvent({required this.type, required this.data});

  final TaskEventType type;
  final Map<String, dynamic> data;

  factory TaskEvent.fromJson(Map<String, dynamic> json) =>
      _$TaskEventFromJson(json);

  Map<String, dynamic> toJson() => _$TaskEventToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
