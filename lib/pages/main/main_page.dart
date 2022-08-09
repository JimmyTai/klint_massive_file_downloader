import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:klint_massive_file_downloader/pages/main/download_item.dart';

import '/providers.dart';

class MainPage extends HookConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  void _keepProvidersAlive(WidgetRef ref) {
    ref.listen(mainViewModel, (prev, next) {});
  }

  void _onParallelTap(BuildContext context, Reader read) {
    final List<String> data = [];
    for (int i = 1; i <= 100; i++) {
      data.add('$i');
    }
    Picker(
      adapter: PickerDataAdapter<String>(pickerdata: data),
      changeToFirst: true,
      itemExtent: 60,
      backgroundColor: Colors.white,
      selecteds: [0],
      selectedTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.w500,
      ),
      textStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      selectionOverlay: Container(
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.black.withOpacity(0.1),
            ),
          ),
        ),
      ),
      confirmTextStyle: const TextStyle(fontSize: 14.0),
      cancelTextStyle: const TextStyle(fontSize: 14.0),
      onSelect: (picker, index, list) {
        read(mainViewModel.notifier).updateParallelCount(count: list[0] + 1);
      },
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    _keepProvidersAlive(ref);
    return WithForegroundTask(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Klint Downloader'),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: [
                  Consumer(
                    builder: (context, ref, child) {
                      final bool isServiceRunning = ref.watch(mainViewModel
                          .select((value) => value.isServiceRunning));
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final int count = ref.watch(mainViewModel
                                  .select((value) => value.parallelCount));
                              return TextButton(
                                onPressed: !isServiceRunning
                                    ? () => _onParallelTap(context, ref.read)
                                    : null,
                                child: Text('Parallel: $count'),
                              );
                            },
                          ),
                          const SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: !isServiceRunning
                                ? () {
                                    ref.read(mainViewModel).start();
                                  }
                                : null,
                            child: const Text('Start'),
                          ),
                          const SizedBox(width: 16.0),
                          ElevatedButton(
                            onPressed: isServiceRunning
                                ? () {
                                    ref.read(mainViewModel).stop();
                                  }
                                : null,
                            child: const Text('Stop'),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Consumer(
                    builder: (context, ref, child) {
                      final int downloadedFileCount = ref.watch(mainViewModel
                          .select((value) => value.downloadedFileCount));
                      final String totalBytesDisplay = ref.watch(mainViewModel
                          .select((value) => value.totalBytesDisplay));
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Downloaded: $downloadedFileCount'),
                          const SizedBox(width: 16.0),
                          Text(totalBytesDisplay),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final bool loading = ref.watch(mainViewModel
                            .select((value) => value.startLoading));
                        final List<DownloadItemViewModel> list = ref.watch(
                            mainViewModel.select(
                                (value) => value.downloadItemViewModels));
                        if (loading) {
                          return const UnconstrainedBox(
                            child: SizedBox.square(
                              dimension: 80.0,
                              child: RepaintBoundary(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          itemBuilder: (context, index) {
                            return ProviderScope(
                              overrides: [
                                downloadItemViewModel
                                    .overrideWithValue(list[index])
                              ],
                              child: DownloadItem(
                                key: ValueKey(list[index].fileName),
                              ),
                            );
                          },
                          separatorBuilder: ((context, index) {
                            return const Divider(height: 1.0);
                          }),
                          itemCount: list.length,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
