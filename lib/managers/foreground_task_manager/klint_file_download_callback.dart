import 'dart:isolate';

import 'package:klint_massive_file_downloader/models.dart';

import '/services.dart';

class KlintFileDownloadCallback extends FileDownloadCallback {
  KlintFileDownloadCallback();

  SendPort? _sendPort;

  void setSendPort({required SendPort? sendPort}) {
    _sendPort = sendPort;
  }

  @override
  void onStart(String fileName) {
    final TaskEvent event = TaskEvent(
      type: TaskEventType.downloadFileStatus,
      data: FileDownloadEvent.start(fileName: fileName).toJson(),
    );
    _sendPort?.send(event.toJson());
  }

  @override
  void onProgressUpdate(String fileName, int count, int total) {
    final TaskEvent event = TaskEvent(
      type: TaskEventType.downloadFileStatus,
      data: FileDownloadEvent.progress(
        fileName: fileName,
        count: count,
        total: total,
      ).toJson(),
    );
    _sendPort?.send(event.toJson());
  }

  @override
  void onEnd(String fileName) {
    final TaskEvent event = TaskEvent(
      type: TaskEventType.downloadFileStatus,
      data: FileDownloadEvent.end(fileName: fileName).toJson(),
    );
    _sendPort?.send(event.toJson());
  }
}
