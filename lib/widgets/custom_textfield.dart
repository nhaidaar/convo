import 'package:convo/config/theme.dart';
import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool isPassword;
  final String? hintText;
  final VoidCallback? action;
  const CustomFormField({
    super.key,
    this.focusNode,
    this.controller,
    this.hintText,
    this.obscureText = false,
    this.isPassword = false,
    this.action,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: focusNode,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
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
      ),
    );
  }
}
