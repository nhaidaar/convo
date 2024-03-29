import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/common/models/user_model.dart';
import 'package:convo/src/common/widgets/default_avatar.dart';
import 'package:flutter/material.dart';

class SelectedMemberCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onTap;
  const SelectedMemberCard({super.key, required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[100],
        ),
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: user.profilePicture.toString(),
              imageBuilder: (context, imageProvider) {
                return DefaultAvatar(radius: 20, image: imageProvider);
              },
              placeholder: (context, url) {
                return const DefaultAvatar(radius: 20);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              '@${user.username.toString()}',
              style: semiboldTS,
            ),
          ],
        ),
      ),
    );
  }
}
