import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'download_service_event.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DownloadServiceEvent {
  const DownloadServiceEvent({
    required this.downloadedFileCount,
    required this.totalMb,
  });

  final int downloadedFileCount;
  final double totalMb;

  factory DownloadServiceEvent.fromJson(Map<String, dynamic> json) =>
      _$DownloadServiceEventFromJson(json);

  Map<String, dynamic> toJson() => _$DownloadServiceEventToJson(this);

  @override
  String toString() => jsonEncode(toJson());
}
