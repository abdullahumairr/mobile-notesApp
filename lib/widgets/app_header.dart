import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset('images/logo.png', width: 30, height: 30),
        const SizedBox(width: 8),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: 'Kodein',
                style: TextStyle(color: Colors.black),
              ),
              WidgetSpan(
                child: SizedBox(width: 4),
              ),
              TextSpan(
                text: 'Notes',
                style: TextStyle(color: Colors.deepOrangeAccent),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
