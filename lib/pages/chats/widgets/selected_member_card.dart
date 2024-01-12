import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:flutter/material.dart';

class SelectedMemberCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? action;
  const SelectedMemberCard({super.key, required this.user, this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
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
                return CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  foregroundImage: imageProvider,
                );
              },
              placeholder: (context, url) {
                return const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    'assets/images/profile.jpg',
                  ),
                );
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
