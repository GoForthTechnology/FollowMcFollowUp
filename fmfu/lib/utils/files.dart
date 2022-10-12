import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

void downloadJson(String content, String fileName) async {
  downloadFile(
    content: content,
    mimeType: 'application/json',
    fileName: fileName,
  );
}

void downloadFile({required String content, required String mimeType, required fileName}) async {
  final String? path = await getSavePath(suggestedName: fileName);
  if (path == null) {
    // Operation was canceled by the user.
    return;
  }
  final Uint8List fileData = Uint8List.fromList(content.codeUnits);
  const String mimeType = 'text/plain';
  final XFile textFile =
  XFile.fromData(fileData, mimeType: mimeType, name: fileName);
  await textFile.saveTo(path);
}