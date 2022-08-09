// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_download_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileDownloadEvent _$FileDownloadEventFromJson(Map<String, dynamic> json) =>
    FileDownloadEvent(
      type: $enumDecode(_$FileDownloadEventTypeEnumMap, json['type']),
      fileName: json['file_name'] as String,
      count: json['count'] as int,
      total: json['total'] as int,
    );

Map<String, dynamic> _$FileDownloadEventToJson(FileDownloadEvent instance) =>
    <String, dynamic>{
      'type': _$FileDownloadEventTypeEnumMap[instance.type]!,
      'file_name': instance.fileName,
      'count': instance.count,
      'total': instance.total,
    };

const _$FileDownloadEventTypeEnumMap = {
  FileDownloadEventType.start: 'start',
  FileDownloadEventType.progress: 'progress',
  FileDownloadEventType.end: 'end',
};
