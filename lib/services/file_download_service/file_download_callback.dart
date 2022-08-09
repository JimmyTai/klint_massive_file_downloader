abstract class FileDownloadCallback {
  void onStart(String fileName);

  void onProgressUpdate(String fileName, int count, int total);

  void onEnd(String fileName);
}
