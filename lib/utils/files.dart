import 'package:file_selector/file_selector.dart';
import 'package:flutter/foundation.dart';

Future<XFile?> openJsonFile() {
  return openFiles().then((files) {
    if (files.isEmpty) {
      return null;
    }
    if (files.length > 1) {
      throw Exception("Opening multiple files is not supported");
    }
    return files.first;
  });
}

void downloadJson(String content, String fileName) async {
  downloadFile(
    content: content,
    mimeType: 'application/json',
    fileName: fileName,
  );
}

void downloadFile({required String content, required String mimeType, required fileName}) async {
  // TODO fix this;
  const String? path = null; //await getSavePath(suggestedName: fileName);
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