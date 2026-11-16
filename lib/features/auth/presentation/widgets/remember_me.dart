import 'package:flutter/material.dart';

class RememberMe extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RememberMe({super.key, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      child: CheckboxListTile(
        value: value,
        onChanged: (newValue) {
          onChanged(newValue ?? false);
        },
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: const Text('Remember me', style: TextStyle(fontSize: 14)),
        activeColor: const Color(0xFF2457D6),
      ),
    );
  }
}
