import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fimber/fimber.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import 'file_download_service/file_download_callback.dart';

export 'file_download_service/file_download_callback.dart';

class _ProgressData {
  const _ProgressData(this.count, this.total);

  final int count;
  final int total;
}

class _FileQueueData {
  const _FileQueueData(this.fileName, this.cancelToken);

  final String fileName;
  final CancelToken cancelToken;
}

class FileDownloadService {
  static const String tag = 'FileDownloadService';

  FileDownloadService({
    this.url = 'https://speed.hetzner.de/100MB.bin',
    this.maxParallelProcess = 20,
  }) : _dio = Dio();

  final Dio _dio;
  final String url;
  final int maxParallelProcess;

  FileDownloadCallback? _callback;
  final List<_FileQueueData> _queue = <_FileQueueData>[];

  int get downloadedFileCount => _downloadedFileCount;
  int _downloadedFileCount = 0;

  double get totalMb => _totalMb;
  double _totalMb = 0;

  void start({required FileDownloadCallback callback}) {
    _callback = callback;
    _scheduleQueue();
  }

  void stop() {
    _callback = null;
    for (final _FileQueueData data in _queue) {
      data.cancelToken.cancel('stop');
    }
    _queue.clear();
  }

  void _scheduleQueue() {
    final int count = maxParallelProcess - _queue.length;
    if (count <= 0) return;
    for (int i = 0; i < count; i++) {
      _downloadFile(url: url);
    }
  }

  Future<void> _downloadFile({
    required String url,
  }) async {
    final String fileName = const Uuid().v4();
    StreamSubscription? subscription;
    try {
      final Directory dir = await path.getTemporaryDirectory();
      final CancelToken cancelToken = CancelToken();
      int lastProgressCount = 0;
      final BehaviorSubject<_ProgressData> countSubject =
          BehaviorSubject.seeded(const _ProgressData(0, 0));
      subscription = countSubject
          .sampleTime(const Duration(seconds: 1))
          .listen((progress) {
        _totalMb += ((progress.count - lastProgressCount) / 1024.0 / 1024.0);
        _callback?.onProgressUpdate(fileName, progress.count, progress.total);
        lastProgressCount = progress.count;
      });
      _queue.add(_FileQueueData(fileName, cancelToken));
      final File file = File('${dir.path}/$fileName');
      _callback?.onStart(fileName);
      await _dio.download(
        url,
        file.path,
        cancelToken: cancelToken,
        onReceiveProgress: (count, total) {
          countSubject.add(_ProgressData(count, total));
        },
      );
      await file.delete();
      Fimber.e('[$tag] download file success');
    } catch (e) {
      if (e is DioError && e.type == DioErrorType.cancel) {
      } else {
        Fimber.e('[$tag] download file with exception', ex: e);
      }
    } finally {
      _downloadedFileCount++;
      subscription?.cancel();
      _queue.removeWhere((element) => element.fileName == fileName);
      _callback?.onEnd(fileName);
    }
    _scheduleQueue();
  }
}
