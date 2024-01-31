import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/widgets/default_avatar.dart';
import 'package:flutter/material.dart';

class SearchCard extends StatelessWidget {
  final UserModel model;
  final VoidCallback? onTap;
  final bool showIcon;
  const SearchCard({
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
                    model.displayName.toString(),
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
            showIcon
                ? Image.asset(
                    'assets/icons/send.png',
                    scale: 2,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
