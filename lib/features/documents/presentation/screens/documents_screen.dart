import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/document_remote_datasource.dart';
import '../../data/repositories/document_repository_impl.dart';
import '../../domain/entities/document_entity.dart';
import '../../domain/usecases/delete_document.dart';
import '../../domain/usecases/get_documents.dart';
import '../../domain/usecases/upload_document.dart';
import '../providers/document_provider.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  late final DocumentProvider _provider;

  @override
  void initState() {
    super.initState();

    final dataSource = DocumentRemoteDataSourceImpl();

    final repository = DocumentRepositoryImpl(remoteDataSource: dataSource);

    _provider = DocumentProvider(
      getDocuments: GetDocuments(repository),
      uploadDocument: UploadDocument(repository),
      deleteDocument: DeleteDocument(repository),
    );

    _provider.loadDocuments();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  // Pick a single document from device.
  Future<void> _pickDocument() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: [
          'pdf',
          'doc',
          'docx',
          'xls',
          'xlsx',
          'ppt',
          'pptx',
          'txt',
          'jpg',
          'jpeg',
          'png',
        ],
      );

      if (file == null) {
        return;
      }

      final extension = file.extension?.toUpperCase() ?? 'FILE';

      final fileLength = file.lengthSync() ?? await file.length();

      final document = DocumentEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: file.name,
        fileType: extension,
        fileSize: _formatFileSize(fileLength ?? 0),
        uploadedAt: DateTime.now(),
        status: DocumentStatus.pending,
      );

      await _provider.addDocument(document);

      if (!mounted) return;

      if (_provider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${file.name} added successfully.')),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(_provider.errorMessage!)));
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Unable to select the document.')),
      );
    }
  }

  // Format file size.
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text(
          'My Documents',
          style: TextStyle(
            color: Color(0xFF172B4D),
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedBuilder(
        animation: _provider,
        builder: (context, child) {
          if (_provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_provider.errorMessage != null && _provider.documents.isEmpty) {
            return Center(child: Text(_provider.errorMessage!));
          }

          if (_provider.documents.isEmpty) {
            return const Center(child: Text('No documents found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _provider.documents.length,
            itemBuilder: (context, index) {
              final document = _provider.documents[index];

              return _DocumentCard(
                document: document,
                onDelete: () => _confirmDelete(document),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickDocument,
        backgroundColor: const Color(0xFF2457D6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.upload_file_rounded),
        label: const Text('Upload'),
      ),
    );
  }

  // Delete confirmation.
  void _confirmDelete(DocumentEntity document) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Delete Document?'),
          content: Text('Are you sure you want to delete ${document.name}?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                _provider.removeDocument(document.id);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}

// Document Card Widget.
class _DocumentCard extends StatelessWidget {
  final DocumentEntity document;
  final VoidCallback onDelete;

  const _DocumentCard({required this.document, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(document.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8EDF5)),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: _getFileColor(document.fileType).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getFileIcon(document.fileType),
              color: _getFileColor(document.fileType),
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF172B4D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${document.fileType} • ${document.fileSize}',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF718096),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _getStatusText(document.status),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            tooltip: 'Delete document',
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.approved:
        return const Color(0xFF16A36A);
      case DocumentStatus.pending:
        return const Color(0xFFEA9B24);
      case DocumentStatus.rejected:
        return const Color(0xFFE53935);
    }
  }

  String _getStatusText(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.approved:
        return 'Approved';
      case DocumentStatus.pending:
        return 'Pending';
      case DocumentStatus.rejected:
        return 'Rejected';
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return Icons.picture_as_pdf_rounded;
      case 'DOCX':
      case 'DOC':
        return Icons.description_rounded;
      case 'XLSX':
      case 'XLS':
        return Icons.table_chart_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  Color _getFileColor(String fileType) {
    switch (fileType.toUpperCase()) {
      case 'PDF':
        return const Color(0xFFE53935);
      case 'DOCX':
      case 'DOC':
        return const Color(0xFF2457D6);
      case 'XLSX':
      case 'XLS':
        return const Color(0xFF16A36A);
      default:
        return const Color(0xFF718096);
    }
  }
}
