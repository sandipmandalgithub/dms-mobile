import '../entities/document_entity.dart';

abstract class DocumentRepository {
  Future<List<DocumentEntity>> getDocuments();

  Future<DocumentEntity?> getDocumentById(String id);

  Future<void> uploadDocument(DocumentEntity document);

  Future<void> deleteDocument(String id);
}
