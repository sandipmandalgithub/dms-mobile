import 'package:flutter/material.dart';

import '../../domain/entities/document_entity.dart';
import '../../domain/usecases/delete_document.dart';
import '../../domain/usecases/get_documents.dart';
import '../../domain/usecases/upload_document.dart';

class DocumentProvider extends ChangeNotifier {
  final GetDocuments getDocuments;
  final UploadDocument uploadDocument;
  final DeleteDocument deleteDocument;

  DocumentProvider({
    required this.getDocuments,
    required this.uploadDocument,
    required this.deleteDocument,
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

  Future<void> addDocument(DocumentEntity document) async {
    try {
      await uploadDocument(document);
      await loadDocuments();
    } catch (error) {
      _errorMessage = 'Unable to upload document.';
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
