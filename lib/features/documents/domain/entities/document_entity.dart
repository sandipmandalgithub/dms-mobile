enum DocumentStatus { pending, approved, rejected }

class DocumentEntity {
  final String id;
  final String name;
  final String fileType;
  final String fileSize;
  final DateTime uploadedAt;
  final DocumentStatus status;
  final String? filePath;

  const DocumentEntity({
    required this.id,
    required this.name,
    required this.fileType,
    required this.fileSize,
    required this.uploadedAt,
    required this.status,
    this.filePath,
  });
}
