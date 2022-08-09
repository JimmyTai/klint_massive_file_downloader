import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:bot_toast/bot_toast.dart';

import 'router.gr.dart';

class App extends ConsumerStatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return HookBuilder(builder: (context) {
      return MaterialApp.router(
        builder: BotToastInit(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        routerDelegate: _appRouter.delegate(
          initialRoutes: [
            const SplashRoute(),
          ],
          navigatorObservers: () => [BotToastNavigatorObserver()],
        ),
        theme: ThemeData(useMaterial3: true),
      );
    });
  }
}
