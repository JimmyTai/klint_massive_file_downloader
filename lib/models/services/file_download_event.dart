import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'file_download_event.g.dart';

enum FileDownloadEventType { start, progress, end }

@JsonSerializable(fieldRename: FieldRename.snake)
class FileDownloadEvent {
  factory FileDownloadEvent.start({
    required String fileName,
  }) =>
      FileDownloadEvent(
        type: FileDownloadEventType.start,
        fileName: fileName,
        count: 0,
        total: 0,
      );

  factory FileDownloadEvent.progress({
    required String fileName,
    required int count,
    required int total,
  }) =>
      FileDownloadEvent(
        type: FileDownloadEventType.progress,
        fileName: fileName,
        count: count,
        total: total,
      );

  factory FileDownloadEvent.end({
    required String fileName,
  }) =>
      FileDownloadEvent(
        type: FileDownloadEventType.end,
        fileName: fileName,
        count: 0,
        total: 0,
      );

  FileDownloadEvent({
    required this.type,
    required this.fileName,
    required this.count,
    required this.total,
  });

  final FileDownloadEventType type;
  final String fileName;
  final int count;
  final int total;

  factory FileDownloadEvent.fromJson(Map<String, dynamic> json) =>
      _$FileDownloadEventFromJson(json);

  Map<String, dynamic> toJson() => _$FileDownloadEventToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
