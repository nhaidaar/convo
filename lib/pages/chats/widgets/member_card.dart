import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:flutter/material.dart';

class MemberCard extends StatelessWidget {
  final UserModel model;
  final VoidCallback? action;
  final bool isAdmin;
  const MemberCard({
    super.key,
    required this.model,
    this.action,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action,
      child: Container(
        height: 90,
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            CachedNetworkImage(
              imageUrl: model.profilePicture.toString(),
              imageBuilder: (context, imageProvider) {
                return CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  foregroundImage: imageProvider,
                );
              },
              placeholder: (context, url) {
                return const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.transparent,
                  backgroundImage: AssetImage(
                    'assets/images/profile.jpg',
                  ),
                );
              },
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    model.displayName.toString(),
                    style: semiboldTS.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@${model.username}',
                    style: mediumTS.copyWith(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            isAdmin
                ? Text(
                    'Admin',
                    style: semiboldTS,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
