import '../models/document_model.dart';
import '../../domain/entities/document_entity.dart';

abstract class DocumentRemoteDataSource {
  Future<List<DocumentModel>> getDocuments();

  Future<DocumentModel?> getDocumentById(String id);

  Future<void> uploadDocument(DocumentModel document);

  Future<void> deleteDocument(String id);
}

class DocumentRemoteDataSourceImpl implements DocumentRemoteDataSource {
  final List<DocumentModel> _documents = [
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

  @override
  Future<List<DocumentModel>> getDocuments() async {
    return List.unmodifiable(_documents);
  }

  @override
  Future<DocumentModel?> getDocumentById(String id) async {
    for (final document in _documents) {
      if (document.id == id) {
        return document;
      }
    }

    return null;
  }

  @override
  Future<void> uploadDocument(DocumentModel document) async {
    _documents.add(document);
  }

  @override
  Future<void> deleteDocument(String id) async {
    _documents.removeWhere((document) => document.id == id);
  }
}
