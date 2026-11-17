import 'dart:typed_data';

import 'package:flutter/material.dart';

class ImagePreviewScreen extends StatelessWidget {
  final Uint8List fileBytes;
  final String fileName;

  const ImagePreviewScreen({
    super.key,
    required this.fileBytes,
    required this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101114),
      appBar: AppBar(
        title: Text(
          fileName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: const Color(0xFF101114),
        foregroundColor: Colors.white,
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5,
        child: Center(
          child: Image.memory(
            fileBytes,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Text(
                'Unable to display image.',
                style: TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }
}
