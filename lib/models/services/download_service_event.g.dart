// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_service_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DownloadServiceEvent _$DownloadServiceEventFromJson(
        Map<String, dynamic> json) =>
    DownloadServiceEvent(
      downloadedFileCount: json['downloaded_file_count'] as int,
      totalMb: (json['total_mb'] as num).toDouble(),
    );

Map<String, dynamic> _$DownloadServiceEventToJson(
        DownloadServiceEvent instance) =>
    <String, dynamic>{
      'downloaded_file_count': instance.downloadedFileCount,
      'total_mb': instance.totalMb,
    };
