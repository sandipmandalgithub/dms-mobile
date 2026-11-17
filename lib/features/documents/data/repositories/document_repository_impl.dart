import '../../domain/entities/document_entity.dart';
import '../../domain/repositories/document_repository.dart';
import '../datasources/document_remote_datasource.dart';
import '../datasources/local_document_datasource.dart';
import '../models/document_model.dart';

import 'package:file_picker/file_picker.dart';

class DocumentRepositoryImpl implements DocumentRepository {
  final DocumentRemoteDataSource remoteDataSource;
  final LocalDocumentDataSource localDataSource;

  DocumentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

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
      filePath: document.filePath,
    );

    await remoteDataSource.uploadDocument(model);
  }

  Future<DocumentEntity> saveAndUploadDocument(
    PlatformFile file,
    DocumentEntity document,
  ) async {
    final savedPath = await localDataSource.saveFile(file);

    final savedDocument = DocumentModel(
      id: document.id,
      name: document.name,
      fileType: document.fileType,
      fileSize: document.fileSize,
      uploadedAt: document.uploadedAt,
      status: document.status,
      filePath: savedPath,
    );

    await remoteDataSource.uploadDocument(savedDocument);

    return savedDocument;
  }

  @override
  Future<void> deleteDocument(String id) async {
    final document = await remoteDataSource.getDocumentById(id);

    if (document?.filePath != null) {
      await localDataSource.deleteFile(document!.filePath!);
    }

    await remoteDataSource.deleteDocument(id);
  }
}
