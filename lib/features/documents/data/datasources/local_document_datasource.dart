import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

class LocalDocumentDataSource {
  static const String _boxName = 'document_files';

  static Future<Box<dynamic>>? _boxFuture;

  Future<Box<dynamic>> _getBox() {
    _boxFuture ??= Hive.openBox<dynamic>(_boxName);
    return _boxFuture!;
  }

  Future<String> saveFile(PlatformFile file) async {
    final box = await _getBox();

    final fileBytes = await file.readAsBytes();

    final storageKey = '${DateTime.now().microsecondsSinceEpoch}_${file.name}';

    await box.put(storageKey, fileBytes.toList());

    return storageKey;
  }

  Future<Uint8List?> readFile(String storageKey) async {
    final box = await _getBox();

    final storedBytes = box.get(storageKey);

    if (storedBytes == null) {
      return null;
    }

    return Uint8List.fromList(List<int>.from(storedBytes));
  }

  Future<void> deleteFile(String storageKey) async {
    final box = await _getBox();

    if (box.containsKey(storageKey)) {
      await box.delete(storageKey);
    }
  }

  Future<bool> fileExists(String storageKey) async {
    final box = await _getBox();

    return box.containsKey(storageKey);
  }
}
