import 'package:flutter/material.dart';

class LoginCircle extends StatelessWidget {
  final String iconUrl;
  final VoidCallback? action;
  const LoginCircle({super.key, this.action, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 60,
        width: 60,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: Colors.grey),
        ),
        child: Image.asset(
          iconUrl,
          scale: 1.5,
        ),
      ),
    );
  }
}
