import 'package:flutter/material.dart';

class DefaultLeading extends StatelessWidget {
  const DefaultLeading({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.of(context).pop(),
      icon: const Icon(Icons.arrow_back_ios_new),
    );
  }
}
