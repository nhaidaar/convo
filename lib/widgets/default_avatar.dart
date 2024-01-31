import 'package:flutter/material.dart';

class DefaultAvatar extends StatelessWidget {
  final ImageProvider<Object>? image;
  final double radius;
  const DefaultAvatar({super.key, this.image, this.radius = 24});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.transparent,
      backgroundImage: const AssetImage(
        'assets/images/profile.jpg',
      ),
      foregroundImage: image,
    );
  }
}
