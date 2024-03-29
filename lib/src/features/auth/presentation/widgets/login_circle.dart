import 'package:flutter/material.dart';

class LoginCircleWidget extends StatelessWidget {
  final String iconUrl;
  final VoidCallback? onTap;
  const LoginCircleWidget({super.key, this.onTap, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
