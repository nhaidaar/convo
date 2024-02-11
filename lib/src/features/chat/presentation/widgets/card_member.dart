import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/common/models/user_model.dart';
import 'package:convo/src/common/widgets/default_avatar.dart';
import 'package:flutter/material.dart';

import '../../domain/models/grouproom_model.dart';

class MemberCard extends StatelessWidget {
  final UserModel model;
  final VoidCallback? onTap;
  final bool isAdmin;
  final bool isYou;
  const MemberCard({
    super.key,
    required this.model,
    this.onTap,
    this.isAdmin = false,
    this.isYou = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
                return DefaultAvatar(image: imageProvider);
              },
              placeholder: (context, url) {
                return const DefaultAvatar();
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
                    isYou ? 'You' : model.displayName.toString(),
                    style: semiboldTS.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '@${model.username}',
                    style: mediumTS.copyWith(fontSize: 15, color: Colors.grey),
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

class SameGroupCard extends StatelessWidget {
  final GroupRoomModel model;
  final VoidCallback? onTap;
  final bool showIcon;
  const SameGroupCard({
    super.key,
    required this.model,
    this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
              imageUrl: model.groupPicture.toString(),
              imageBuilder: (context, imageProvider) {
                return DefaultAvatar(image: imageProvider);
              },
              placeholder: (context, url) {
                return const DefaultAvatar();
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
                    model.title.toString(),
                    style: semiboldTS.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${model.members!.length + 1} members',
                    style: mediumTS.copyWith(fontSize: 15, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
