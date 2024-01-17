import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:flutter/material.dart';

class SameGroupCard extends StatelessWidget {
  final GroupRoomModel model;
  final VoidCallback? action;
  final bool showIcon;
  const SameGroupCard({
    super.key,
    required this.model,
    this.action,
    this.showIcon = true,
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
              imageUrl: model.groupPicture.toString(),
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
                    model.title.toString(),
                    style: semiboldTS.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${model.members!.length + 1} members',
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
          ],
        ),
      ),
    );
  }
}
