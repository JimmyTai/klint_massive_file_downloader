import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:fimber/fimber.dart';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '/services.dart';
import '/models.dart';
import 'klint_file_download_callback.dart';

class ForegroundTaskHandler extends TaskHandler {
  static const String tag = 'ForegroundTaskHandler';

  ForegroundTaskHandler() {
    // if (kDebugMode) {
    Fimber.plantTree(DebugTree());
    // }
  }

  final KlintFileDownloadCallback _callback = KlintFileDownloadCallback();
  FileDownloadService? _service;

  @override
  Future<void> onStart(DateTime timestamp, SendPort? sendPort) async {
    Fimber.d('[$tag] onStart');
    final int maxParallelProcess =
        (await FlutterForegroundTask.getData<int>(key: 'maxParallelProcess')) ??
            1;
    _service = FileDownloadService(maxParallelProcess: maxParallelProcess);
    _callback.setSendPort(sendPort: sendPort);
    _service?.start(callback: _callback);
    _reportDownloadService(sendPort);
  }

  @override
  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    Fimber.d('[$tag] onEvent');
    _callback.setSendPort(sendPort: sendPort);
    _reportDownloadService(sendPort);
  }

  @override
  Future<void> onDestroy(DateTime timestamp, SendPort? sendPort) async {
    Fimber.d('[$tag] onDestroy');
    _callback.setSendPort(sendPort: sendPort);
    _service?.stop();
  }

  void _reportDownloadService(SendPort? sendPort) {
    if (_service == null) return;
    sendPort?.send(
      TaskEvent(
        type: TaskEventType.downloadService,
        data: DownloadServiceEvent(
          downloadedFileCount: _service!.downloadedFileCount,
          totalMb: _service!.totalMb,
        ).toJson(),
      ).toJson(),
    );
  }
}
