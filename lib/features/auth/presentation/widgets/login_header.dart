import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            height: 72,
            width: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF2457D6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.folder_copy_rounded,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'DMS Mobile',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color(0xFF172B4D),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Document Management System',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15, color: Color(0xFF718096)),
        ),
      ],
    );
  }
}
