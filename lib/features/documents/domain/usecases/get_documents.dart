import '../entities/document_entity.dart';
import '../repositories/document_repository.dart';

class GetDocuments {
  final DocumentRepository repository;

  const GetDocuments(this.repository);

  Future<List<DocumentEntity>> call() {
    return repository.getDocuments();
  }
}
