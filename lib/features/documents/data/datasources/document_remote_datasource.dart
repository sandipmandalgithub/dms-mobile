import 'package:hive_ce_flutter/hive_flutter.dart';

import '../models/document_model.dart';
import '../../domain/entities/document_entity.dart';

abstract class DocumentRemoteDataSource {
  Future<List<DocumentModel>> getDocuments();

  Future<DocumentModel?> getDocumentById(String id);

  Future<void> uploadDocument(DocumentModel document);

  Future<void> deleteDocument(String id);
}

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  static const String _boxName = 'documents_metadata';

  static Future<Box<dynamic>>? _boxFuture;

  Future<Box<dynamic>> _getBox() {
    _boxFuture ??= Hive.openBox<dynamic>(_boxName);
    return _boxFuture!;
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
    final box = await _getBox();

    if (box.isNotEmpty) return;

    final initialDocuments = _getInitialDocuments();

    for (final document in initialDocuments) {
      await box.put(document.id, document.toJson());
    }
  }

  @override
  Future<List<DocumentModel>> getDocuments() async {
    await _ensureInitialized();

    final box = await _getBox();

    return box.values.map((value) {
      return DocumentModel.fromJson(Map<String, dynamic>.from(value as Map));
    }).toList();
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    await _ensureInitialized();

    final box = await _getBox();
    final value = box.get(id);

    if (value == null) return null;

    return DocumentModel.fromJson(Map<String, dynamic>.from(value as Map));
  }

  @override
  Future<void> uploadDocument(DocumentModel document) async {
    await _ensureInitialized();

    final box = await _getBox();

    await box.put(document.id, document.toJson());
  }

  @override
  Future<void> deleteDocument(String id) async {
    await _ensureInitialized();

    final box = await _getBox();

    await box.delete(id);
  }
}
