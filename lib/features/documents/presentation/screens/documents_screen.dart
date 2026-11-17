import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../data/datasources/document_remote_datasource.dart';
import '../../data/datasources/local_document_datasource.dart';
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

    final remoteDataSource = DocumentRemoteDataSourceImpl();
    final localDataSource = LocalDocumentDataSource();

    final repository = DocumentRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );

    _provider = DocumentProvider(
      getDocuments: GetDocuments(repository),
      uploadDocument: UploadDocument(repository),
      deleteDocument: DeleteDocument(repository),
      localDataSource: localDataSource,
    );

    _provider.loadDocuments();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

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

      if (file == null || !mounted) return;

      final fileLength = await file.length();

      if (fileLength == null) {
        throw Exception('Unable to read file size.');
      }

      final extension = file.extension?.toUpperCase() ?? 'FILE';

      final document = DocumentEntity(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        name: file.name,
        fileType: extension,
        fileSize: _formatFileSize(fileLength),
        uploadedAt: DateTime.now(),
        status: DocumentStatus.pending,
      );

      await _provider.addDocument(file, document);

      if (!mounted) return;

      if (_provider.errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Document saved successfully.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_provider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to upload document: $error'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    }

    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }

    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  Color _getStatusColor(DocumentStatus status) {
    switch (status) {
      case DocumentStatus.approved:
        return Colors.green;
      case DocumentStatus.pending:
        return Colors.orange;
      case DocumentStatus.rejected:
        return Colors.red;
    }
  }

  IconData _getFileIcon(String fileType) {
    switch (fileType.toLowerCase()) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'ppt':
      case 'pptx':
        return Icons.slideshow;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
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

  Future<void> _deleteDocument(DocumentEntity document) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Document'),
          content: Text('Are you sure you want to delete "${document.name}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    await _provider.removeDocument(document.id);

    if (!mounted) return;

    if (_provider.errorMessage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document deleted successfully.')),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_provider.errorMessage!)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Documents',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _pickDocument,
            icon: const Icon(Icons.add),
            tooltip: 'Upload Document',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _provider,
        builder: (context, child) {
          if (_provider.isLoading && _provider.documents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_provider.documents.isEmpty) {
            return _buildEmptyState();
          }

          return RefreshIndicator(
            onRefresh: _provider.loadDocuments,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildSummary(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Documents',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_provider.documents.length} files',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ..._provider.documents.map(_buildDocumentCard),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickDocument,
        icon: const Icon(Icons.upload_file),
        label: const Text('Upload File'),
      ),
    );
  }

  Widget _buildSummary() {
    final documents = _provider.documents;

    final approved = documents
        .where((doc) => doc.status == DocumentStatus.approved)
        .length;

    final pending = documents
        .where((doc) => doc.status == DocumentStatus.pending)
        .length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Total Files',
            documents.length.toString(),
            Icons.folder,
            Colors.blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            'Approved',
            approved.toString(),
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildSummaryCard(
            'Pending',
            pending.toString(),
            Icons.pending_actions,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(DocumentEntity document) {
    final statusColor = _getStatusColor(document.status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            _getFileIcon(document.fileType),
            color: Colors.blue,
            size: 25,
          ),
        ),
        title: Text(
          document.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${document.fileType} • ${document.fileSize}',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
        trailing: IconButton(
          onPressed: () => _deleteDocument(document),
          icon: const Icon(Icons.delete_outline, color: Colors.red),
          tooltip: 'Delete Document',
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open, size: 72, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No Documents Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload your first document to get started.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _pickDocument,
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Document'),
            ),
          ],
        ),
      ),
    );
  }
}
