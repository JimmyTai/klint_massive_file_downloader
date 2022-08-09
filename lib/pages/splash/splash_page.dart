import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:auto_route/auto_route.dart';

import '/managers.dart';

import '/router.gr.dart';

class SplashPage extends HookConsumerWidget {
  const SplashPage({Key? key}) : super(key: key);

  Future<void> _initAllService(BuildContext context) async {
    await Future.wait([
      ForegroundTaskManager().init(),
    ]);
    context.router.replace(const MainRoute());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    useEffect(() {
      _initAllService(context);
      return null;
    }, []);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(),
    );
  }
}
