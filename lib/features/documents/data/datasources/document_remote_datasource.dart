import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../models/document_model.dart';
import '../../domain/entities/document_entity.dart';

abstract class DocumentRemoteDataSource {
  Future<List<DocumentModel>> getDocuments();

  Future<DocumentModel?> getDocumentById(String id);

  Future<void> uploadDocument(DocumentModel document);

  Future<void> deleteDocument(String id);
}

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  static const String _fileName = 'documents.json';

  List<DocumentModel>? _documents;

  Future<File> get _storageFile async {
    final directory = await getApplicationDocumentsDirectory();

    return File(path.join(directory.path, _fileName));
  }

  List<DocumentModel> _getInitialDocuments() {
    return [
      DocumentModel(
        id: '1',
        name: 'Project Proposal.pdf',
        fileType: 'PDF',
        fileSize: '2.4 MB',
        uploadedAt: DateTime(2026, 11, 16),
        status: DocumentStatus.approved,
      ),
      DocumentModel(
        id: '2',
        name: 'Employee Report.docx',
        fileType: 'DOCX',
        fileSize: '1.2 MB',
        uploadedAt: DateTime(2026, 11, 15),
        status: DocumentStatus.pending,
      ),
      DocumentModel(
        id: '3',
        name: 'Monthly Budget.xlsx',
        fileType: 'XLSX',
        fileSize: '850 KB',
        uploadedAt: DateTime(2026, 11, 14),
        status: DocumentStatus.approved,
      ),
      DocumentModel(
        id: '4',
        name: 'Company Policy.pdf',
        fileType: 'PDF',
        fileSize: '1.8 MB',
        uploadedAt: DateTime(2026, 11, 13),
        status: DocumentStatus.rejected,
      ),
    ];
  }

  Future<void> _ensureInitialized() async {
    if (_documents != null) return;

    final file = await _storageFile;

    if (await file.exists()) {
      try {
        final content = await file.readAsString();
        final decoded = jsonDecode(content) as List<dynamic>;

        _documents = decoded.map((item) {
          return DocumentModel.fromJson(Map<String, dynamic>.from(item as Map));
        }).toList();

        return;
      } catch (error) {
        throw Exception('Unable to read saved documents: $error');
      }
    }

    _documents = _getInitialDocuments();

    await _saveDocuments();
  }

  Future<void> _saveDocuments() async {
    final file = await _storageFile;

    final content = jsonEncode(
      _documents!.map((document) => document.toJson()).toList(),
    );

    await file.writeAsString(content, flush: true);
  }

  @override
  Future<List<DocumentModel>> getDocuments() async {
    await _ensureInitialized();

    return List.unmodifiable(_documents!);
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    await _ensureInitialized();

    for (final document in _documents!) {
      if (document.id == id) {
        return document;
      }
    }

    return null;
  }

  @override
  Future<void> uploadDocument(DocumentModel document) async {
    await _ensureInitialized();

    final existingIndex = _documents!.indexWhere(
      (item) => item.id == document.id,
    );

    if (existingIndex != -1) {
      _documents![existingIndex] = document;
    } else {
      _documents!.add(document);
    }

    await _saveDocuments();
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _ensureInitialized();

    _documents!.removeWhere((document) => document.id == id);

    await _saveDocuments();
  }
}
