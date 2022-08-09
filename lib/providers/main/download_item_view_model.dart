import 'package:hooks_riverpod/hooks_riverpod.dart';

final downloadItemViewModel =
    StateNotifierProvider<DownloadItemViewModel, DownloadItemState>(
  (ref) => throw UnimplementedError(
      'It need to override value because this is for list view item'),
);

class DownloadItemState {
  const DownloadItemState({
    required this.fileName,
    this.count = 0,
    this.total = 0,
  });

  final String fileName;
  final int count;
  final int total;

  double get progress => total == 0 ? 0 : (count / total);

  String get progressDisplay => '${(progress * 100).round()} %';
}

class DownloadItemViewModel extends StateNotifier<DownloadItemState> {
  DownloadItemViewModel({required DownloadItemState state}) : super(state);

  String get fileName => state.fileName;

  void update({required DownloadItemState state}) {
    this.state = state;
  }
}
