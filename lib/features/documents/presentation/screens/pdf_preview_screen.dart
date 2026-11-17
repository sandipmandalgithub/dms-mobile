import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class PdfPreviewScreen extends StatefulWidget {
  final Uint8List fileBytes;
  final String fileName;

  const PdfPreviewScreen({
    super.key,
    required this.fileBytes,
    required this.fileName,
  });

  @override
  State<PdfPreviewScreen> createState() => _PdfPreviewScreenState();
}

class _PdfPreviewScreenState extends State<PdfPreviewScreen> {
  PdfControllerPinch? _pdfController;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePdf();
  }

  Future<void> _initializePdf() async {
    try {
      final controller = PdfControllerPinch(
        document: PdfDocument.openData(widget.fileBytes),
      );

      if (!mounted) {
        controller.dispose();
        return;
      }

      setState(() {
        _pdfController = controller;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _errorMessage = 'Unable to open PDF document.';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: Text(
          widget.fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.picture_as_pdf_outlined,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      );
    }

    return PdfViewPinch(
      controller: _pdfController!,
      builders: PdfViewPinchBuilders<DefaultBuilderOptions>(
        options: const DefaultBuilderOptions(),
        documentLoaderBuilder: (_) {
          return const Center(child: CircularProgressIndicator());
        },
        pageLoaderBuilder: (_) {
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (_, error) {
          return Center(
            child: Text(
              'Unable to display PDF: $error',
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }
}
