import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:fimber/fimber.dart';

import 'main_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    statusBarColor: Colors.transparent,
    systemNavigationBarColor: Colors.white,
  ));
  _configLogger();
  runApp(
    const ProviderScope(
      child: App(),
    ),
  );
}

void _configLogger() {
  // if (kDebugMode) {
  Fimber.plantTree(DebugTree());
  // }
}
