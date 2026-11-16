import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class GetDocumentById {
  final DocumentRepository repository;

  const GetDocumentById(this.repository);

  Future<DocumentEntity?> call(String id) {
    return repository.getDocumentById(id);
  }
}
