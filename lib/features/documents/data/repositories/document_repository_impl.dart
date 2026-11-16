import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_remote_datasource.dart';
import '../models/document_model.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;

  DocumentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<DocumentEntity>> getDocuments() async {
    return remoteDataSource.getDocuments();
  }

  @override
  Future<DocumentEntity?> getDocumentById(String id) async {
    return remoteDataSource.getDocumentById(id);
  }

  @override
  Future<void> uploadDocument(DocumentEntity document) async {
    final model = DocumentModel(
      id: document.id,
      name: document.name,
      fileType: document.fileType,
      fileSize: document.fileSize,
      uploadedAt: document.uploadedAt,
      status: document.status,
    );

    await remoteDataSource.uploadDocument(model);
  }

  @override
  Future<void> deleteDocument(String id) async {
    await remoteDataSource.deleteDocument(id);
  }
}
