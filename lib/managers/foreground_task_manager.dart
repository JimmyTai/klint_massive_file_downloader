import 'dart:async';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:fimber/fimber.dart';
import 'package:rxdart/subjects.dart';

import '/models.dart';
import 'foreground_task_manager/foreground_task_handler.dart';

void _startCallback() {
  FlutterForegroundTask.setTaskHandler(ForegroundTaskHandler());
}

class ForegroundTaskManager {
  static const String tag = 'ForegroundTaskManager';

  static final ForegroundTaskManager _instance = ForegroundTaskManager._();

  factory ForegroundTaskManager() => _instance;

  ForegroundTaskManager._();

  Completer<void>? _initCompleter;

  bool get initialized => _initCompleter?.isCompleted ?? false;

  Stream<bool> get isRunning => _isRunning.stream;
  final BehaviorSubject<bool> _isRunning = BehaviorSubject.seeded(false);

  Future<void> init() async {
    if (_initCompleter != null) return;
    _initCompleter = Completer<void>();
    await FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'foreground-service',
        channelName: 'Foreground Service',
        channelDescription:
            'This notification appears when the foreground service is running.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: true,
        allowWifiLock: true,
      ),
      printDevLog: true,
    );
    _initCompleter!.complete();
    final bool running = await FlutterForegroundTask.isRunningService;
    _isRunning.add(running);
    Fimber.d('[$tag] manager initialized');
  }

  Future<bool> start({int parallelCount = 1}) async {
    if (!initialized) {
      throw const NotInitializedException.foregroundTaskManager();
    }
    final bool isServiceRuning = await FlutterForegroundTask.isRunningService;
    if (isServiceRuning) {
      return true;
    }
    FlutterForegroundTask.saveData(
        key: 'maxParallelProcess', value: parallelCount);
    final bool result = await FlutterForegroundTask.startService(
      notificationTitle: 'File Downloader',
      notificationText:
          'Files are downloading, you could tap this to see the details.',
      callback: _startCallback,
    );
    _isRunning.add(true);
    return result;
  }

  Future<bool> stop() async {
    final bool suc = await FlutterForegroundTask.stopService();
    if (suc) {
      _isRunning.add(false);
    }
    return suc;
  }
}
