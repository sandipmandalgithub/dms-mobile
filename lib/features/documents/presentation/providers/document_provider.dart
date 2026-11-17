import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/local_document_datasource.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/usecases/delete_document.dart';
import '../../domain/usecases/get_documents.dart';
import '../../domain/usecases/upload_document.dart';

class DocumentProvider extends ChangeNotifier {
  final GetDocuments getDocuments;
  final UploadDocument uploadDocument;
  final DeleteDocument deleteDocument;
  final LocalDocumentDataSource localDataSource;

  DocumentProvider({
    required this.getDocuments,
    required this.uploadDocument,
    required this.deleteDocument,
    required this.localDataSource,
  });

  List<DocumentEntity> _documents = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<DocumentEntity> get documents => _documents;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadDocuments() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _documents = await getDocuments();
    } catch (error) {
      _errorMessage = 'Unable to load documents.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDocument(PlatformFile file, DocumentEntity document) async {
    String? savedPath;

    _errorMessage = null;
    notifyListeners();

    try {
      savedPath = await localDataSource.saveFile(file);

      final savedDocument = DocumentEntity(
        id: document.id,
        name: document.name,
        fileType: document.fileType,
        fileSize: document.fileSize,
        uploadedAt: document.uploadedAt,
        status: document.status,
        filePath: savedPath,
      );

      await uploadDocument(savedDocument);
      await loadDocuments();
    } catch (error) {
      if (savedPath != null) {
        try {
          await localDataSource.deleteFile(savedPath);
        } catch (_) {
          // Preserve the original upload error.
        }
      }

      _errorMessage = 'Unable to save the document.';
      notifyListeners();
    }
  }

  Future<void> removeDocument(String id) async {
    try {
      await deleteDocument(id);
      await loadDocuments();
    } catch (error) {
      _errorMessage = 'Unable to delete document.';
      notifyListeners();
    }
  }
}
