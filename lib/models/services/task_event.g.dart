// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskEvent _$TaskEventFromJson(Map<String, dynamic> json) => TaskEvent(
      type: $enumDecode(_$TaskEventTypeEnumMap, json['type']),
      data: json['data'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$TaskEventToJson(TaskEvent instance) => <String, dynamic>{
      'type': _$TaskEventTypeEnumMap[instance.type]!,
      'data': instance.data,
    };

const _$TaskEventTypeEnumMap = {
  TaskEventType.downloadService: 'downloadService',
  TaskEventType.downloadFileStatus: 'downloadFileStatus',
};
