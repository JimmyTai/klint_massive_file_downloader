import 'dart:async';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:rxdart/utils.dart';
import 'package:fimber/fimber.dart';
import 'package:collection/collection.dart';

import '/models.dart';
import '/managers.dart';
import '/providers.dart';

final mainViewModel = ChangeNotifierProvider(
  (ref) => MainViewModel(read: ref.read),
  name: MainViewModel.tag,
);

class MainViewModel extends ChangeNotifier {
  static const String tag = 'MainViewModel';

  MainViewModel({required Reader read}) : _read = read {
    _setServiceIsRunningObserver();
  }

  final Reader _read;

  final CompositeSubscription _subscriptions = CompositeSubscription();
  StreamSubscription? _eventSub;

  bool get isServiceRunning => _isServiceRunning;
  bool _isServiceRunning = false;

  bool get startLoading => _startLoading;
  bool _startLoading = false;

  UnmodifiableListView<DownloadItemViewModel> get downloadItemViewModels =>
      UnmodifiableListView(_downloadItemViewModels);
  final List<DownloadItemViewModel> _downloadItemViewModels =
      <DownloadItemViewModel>[];

  int get parallelCount => _parallelCount;
  int _parallelCount = 1;

  int get downloadedFileCount => _downloadedFileCount;
  int _downloadedFileCount = 0;

  String get totalBytesDisplay {
    if (_totalMb < 1024) {
      return '${_totalMb.toStringAsFixed(1)} MB';
    } else if (_totalMb < (1024 * 1024)) {
      return '${(_totalMb / 1024.0).toStringAsFixed(1)} GB';
    } else {
      return '${(_totalMb / 1024.0 / 1024.0).toStringAsFixed(1)} TB';
    }
  }

  double _totalMb = 0;

  void updateParallelCount({required int count}) {
    if (count != _parallelCount) {
      _parallelCount = count;
      notifyListeners();
    }
  }

  Future<bool> start() =>
      ForegroundTaskManager().start(parallelCount: _parallelCount);

  Future<bool> stop() => ForegroundTaskManager().stop();

  void _setServiceIsRunningObserver() {
    ForegroundTaskManager().isRunning.listen((running) {
      Fimber.d('[$tag] isServiceRunning: $running');
      if (running) {
        _startLoading = true;
        _setFileDownloadEventListener();
      } else {
        _downloadedFileCount = 0;
        _totalMb = 0.0;
        _downloadItemViewModels.clear();
        _eventSub?.cancel();
        _eventSub = null;
      }
      _isServiceRunning = running;
      notifyListeners();
    }).addTo(_subscriptions);
  }

  Future<void> _setFileDownloadEventListener() async {
    if (_eventSub != null) return;
    final ReceivePort? port = await FlutterForegroundTask.receivePort;
    _eventSub = port?.listen((message) {
      _startLoading = false;
      final TaskEvent event = TaskEvent.fromJson(message);
      Fimber.d('[$tag] file download event: $event');
      switch (event.type) {
        case TaskEventType.downloadService:
          _updateDownloadService(DownloadServiceEvent.fromJson(event.data));
          break;
        case TaskEventType.downloadFileStatus:
          _updateFileStataus(FileDownloadEvent.fromJson(event.data));
          break;
      }
    });
  }

  void _updateDownloadService(DownloadServiceEvent event) {
    _downloadedFileCount = event.downloadedFileCount;
    _totalMb = event.totalMb;
    notifyListeners();
  }

  void _updateFileStataus(FileDownloadEvent event) {
    final DownloadItemState state = DownloadItemState(
      fileName: event.fileName,
      count: event.count,
      total: event.total,
    );
    switch (event.type) {
      case FileDownloadEventType.start:
      case FileDownloadEventType.progress:
        final DownloadItemViewModel? vm = _downloadItemViewModels
            .firstWhereOrNull((element) => element.fileName == event.fileName);
        if (vm == null) {
          _downloadItemViewModels.add(
            DownloadItemViewModel(state: state),
          );
        } else {
          vm.update(state: state);
        }
        break;
      case FileDownloadEventType.end:
        _downloadItemViewModels
            .removeWhere((element) => element.fileName == event.fileName);
        break;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _subscriptions.dispose();
    super.dispose();
  }
}
