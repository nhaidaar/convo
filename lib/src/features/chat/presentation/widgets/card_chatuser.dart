import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/src/common/widgets/default_avatar.dart';
import 'package:flutter/material.dart';

import '../../../../utils/method.dart';
import '../../../../constants/theme.dart';

class ChatUserCard extends StatelessWidget {
  final bool imageCondition;
  final String imageUrl;
  final String title;
  final String subtitle;
  const ChatUserCard(
      {super.key, required this.imageCondition, required this.imageUrl, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          imageCondition
              ? Hero(
                  tag: imageUrl,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) {
                      return DefaultAvatar(
                        radius: 20,
                        image: imageProvider,
                      );
                    },
                    placeholder: (context, url) {
                      return const DefaultAvatar(radius: 20);
                    },
                  ),
                )
              : const DefaultAvatar(radius: 20),
          const SizedBox(
            width: 12,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  title,
                  style: semiboldTS.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: mediumTS.copyWith(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DefaultChatUserCard extends StatelessWidget {
  const DefaultChatUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        children: [
          const DefaultAvatar(),
          const SizedBox(
            width: 16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Convo User',
                  style: semiboldTS.copyWith(fontSize: 18),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  getLastActiveTime(context: context, lastActive: '-1'),
                  style: mediumTS.copyWith(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
