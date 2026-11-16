import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Secure Document Management',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
        ),
        SizedBox(height: 8),
        Text(
          'DMS Mobile Demo • Version 1.0',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, color: Color(0xFFA0AEC0)),
        ),
      ],
    );
  }
}
