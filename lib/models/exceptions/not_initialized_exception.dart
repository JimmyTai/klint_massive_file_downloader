class NotInitializedException implements Exception {
  const NotInitializedException.foregroundTaskManager()
      : message = '[ForegroundTaskManager] had not been initialized.';

  const NotInitializedException({this.message = ''});

  final String message;
}
