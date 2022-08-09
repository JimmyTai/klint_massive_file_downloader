import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:klint_massive_file_downloader/providers/main.dart';

class DownloadItem extends ConsumerWidget {
  const DownloadItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      width: double.infinity,
      height: 80.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Consumer(
            builder: (context, ref, child) {
              final String fileName = ref.watch(
                  downloadItemViewModel.select((value) => value.fileName));
              return Text(
                'File: $fileName',
                overflow: TextOverflow.ellipsis,
              );
            },
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final double progress = ref.watch(downloadItemViewModel
                        .select((value) => value.progress));
                    return LinearProgressIndicator(value: progress);
                  },
                ),
              ),
              const SizedBox(width: 8.0),
              Consumer(
                builder: (context, ref, child) {
                  final String progressDisplay = ref.watch(downloadItemViewModel
                      .select((value) => value.progressDisplay));
                  return Text(progressDisplay);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
