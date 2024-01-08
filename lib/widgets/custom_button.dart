import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final bool invert;
  final bool disabled;
  final VoidCallback? action;
  const CustomButton(
      {super.key,
      required this.title,
      this.action,
      this.invert = false,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: invert ? Colors.white : blue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: invert ? blue : Colors.transparent),
          ),
          child: Text(
            title,
            style: semiboldTS.copyWith(
              color: invert ? blue : Colors.white,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
