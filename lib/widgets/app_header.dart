import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF111827),
      child: Row(
        children: [
          Image.asset('images/logo.png', width: 100, height: 100),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
