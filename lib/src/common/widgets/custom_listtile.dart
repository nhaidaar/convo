import 'package:flutter/material.dart';

import '../../constants/theme.dart';

class CustomListTile extends StatelessWidget {
  final String title;
  final String iconUrl;
  final VoidCallback? onTap;
  final bool isRed;
  const CustomListTile({
    super.key,
    required this.title,
    required this.iconUrl,
    this.onTap,
    this.isRed = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ImageIcon(
        AssetImage(iconUrl),
        color: isRed ? Colors.red : null,
      ),
      title: Text(
        title,
        style: mediumTS.copyWith(
          fontSize: 18,
          color: isRed ? Colors.red : null,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: isRed ? Colors.red : null,
      ),
    );
  }
}
