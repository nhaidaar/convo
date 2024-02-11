import 'package:convo/src/constants/theme.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final double titleSize;
  final double padding;
  final bool invert;
  final bool disabled;
  final VoidCallback? onTap;
  final Color? buttonColor;
  const CustomButton(
      {super.key,
      required this.title,
      this.titleSize = 16,
      this.padding = 16,
      this.onTap,
      this.invert = false,
      this.disabled = false,
      this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: invert ? Colors.white : (buttonColor ?? blue),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: invert ? (buttonColor ?? blue) : Colors.transparent,
            ),
          ),
          child: Text(
            title,
            style: semiboldTS.copyWith(
              color: invert ? (buttonColor ?? blue) : Colors.white,
              fontSize: titleSize,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  final String iconUrl;
  final String title;
  final bool disabled;
  final VoidCallback? onTap;
  final Color? buttonColor;
  final Color? textColor;
  const ButtonWithIcon(
      {super.key,
      required this.iconUrl,
      required this.title,
      this.onTap,
      this.disabled = false,
      this.buttonColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: disabled ? 0.4 : 1,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: buttonColor ?? blue,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: buttonColor ?? Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageIcon(
                AssetImage(iconUrl),
                size: 22,
                color: textColor ?? Colors.white,
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                title,
                style: semiboldTS.copyWith(
                  color: textColor ?? Colors.white,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingButton extends StatelessWidget {
  final Color? buttonColor;
  const LoadingButton({super.key, this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: buttonColor ?? blue,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: buttonColor ?? Colors.transparent),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onTap;
  const FloatingButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FloatingActionButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor: blue,
        child: icon,
      ),
    );
  }
}
