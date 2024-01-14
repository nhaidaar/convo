import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double titleSize;
  final double padding;
  final bool invert;
  final bool disabled;
  final VoidCallback? action;
  const CustomButton(
      {super.key,
      required this.title,
      this.titleSize = 16,
      this.padding = 16,
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
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: invert ? Colors.white : blue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: invert ? blue : Colors.transparent),
          ),
          child: Text(
            title,
            style: semiboldTS.copyWith(
              color: invert ? blue : Colors.white,
              fontSize: titleSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
