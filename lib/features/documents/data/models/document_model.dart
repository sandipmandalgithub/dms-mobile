import '../../domain/entities/document_entity.dart';

class DocumentModel extends DocumentEntity {
  const DocumentModel({
    required super.id,
    required super.name,
    required super.fileType,
    required super.fileSize,
    required super.uploadedAt,
    required super.status,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as String,
      uploadedAt: DateTime.parse(json['uploadedAt'] as String),
      status: DocumentStatus.values.firstWhere(
        (status) => status.name == json['status'],
        orElse: () => DocumentStatus.pending,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'fileType': fileType,
      'fileSize': fileSize,
      'uploadedAt': uploadedAt.toIso8601String(),
      'status': status.name,
    };
  }
}
