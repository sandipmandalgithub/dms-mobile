import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class UploadDocument {
  final DocumentRepository repository;

  const UploadDocument(this.repository);

  Future<void> call(DocumentEntity document) {
    return repository.uploadDocument(document);
  }
}
