import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class LocalDocumentDataSource {
  Future<String> saveFile(PlatformFile file) async {
    final directory = await getApplicationDocumentsDirectory();

    final storageDirectory = Directory(path.join(directory.path, 'documents'));

    if (!await storageDirectory.exists()) {
      await storageDirectory.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().microsecondsSinceEpoch}_${path.basename(file.name)}';

    final savedFilePath = path.join(storageDirectory.path, fileName);

    final fileBytes = await file.readAsBytes();

    await File(savedFilePath).writeAsBytes(fileBytes, flush: true);

    return savedFilePath;
  }

  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<bool> fileExists(String filePath) async {
    return File(filePath).exists();
  }
}
