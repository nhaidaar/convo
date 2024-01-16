import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPassword;
  final bool enabled;
  final String? hintText;
  final VoidCallback? action;
  const CustomFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.isPassword = false,
    this.enabled = true,
    this.hintText,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        enabled: enabled,
        fillColor: enabled ? null : Colors.grey.shade100,
        filled: !enabled,
        suffixIcon: isPassword
            ? InkWell(
                onTap: action,
                child: Ink(
                  child: ImageIcon(
                    AssetImage(
                      !obscureText
                          ? 'assets/icons/password_visible.png'
                          : 'assets/icons/password_invisible.png',
                    ),
                  ),
                ),
              )
            : null,
        hintText: hintText,
        hintStyle: mediumTS.copyWith(fontSize: 14),
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}

class CustomRoundField extends StatelessWidget {
  final Function(String?)? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? prefixIconUrl;
  final String? hintText;
  final Color? fillColor;
  final Color borderColor;
  const CustomRoundField({
    super.key,
    this.onFieldSubmitted,
    this.controller,
    this.focusNode,
    this.prefixIconUrl,
    this.hintText,
    this.fillColor,
    this.borderColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        prefixIcon: prefixIconUrl != null
            ? Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Image.asset(
                  prefixIconUrl.toString(),
                  scale: 2,
                  color: borderColor,
                ),
              )
            : null,
        fillColor: fillColor,
        filled: fillColor != null,
        hintText: hintText,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: borderColor),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide(color: borderColor),
        ),
      ),
    );
  }
}

class MessageField extends StatelessWidget {
  final Function(String?)? onFieldSubmitted;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final VoidCallback? cameraOnTap;
  final VoidCallback? imageOnTap;
  const MessageField(
      {super.key,
      this.onFieldSubmitted,
      this.controller,
      this.focusNode,
      this.cameraOnTap,
      this.imageOnTap});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onFieldSubmitted,
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: cameraOnTap,
                child: Image.asset(
                  'assets/icons/camera.png',
                  scale: 2,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              GestureDetector(
                onTap: imageOnTap,
                child: Image.asset(
                  'assets/icons/photo.png',
                  scale: 2,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: 'Type something...',
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
      ),
    );
  }
}
