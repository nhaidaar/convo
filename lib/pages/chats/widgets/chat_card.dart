import 'package:convo/config/theme.dart';
import 'package:convo/pages/chats/chat_room.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  final String title, lastMessage, lastMessageTime;
  final String profilePictureUrl;
  final int messageUnread;
  const ChatCard(
      {super.key,
      required this.title,
      required this.lastMessage,
      required this.lastMessageTime,
      required this.profilePictureUrl,
      required this.messageUnread});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatRoom(),
          ),
        );
      },
      child: Container(
        height: 90,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.grey[100],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.transparent,
              backgroundImage: AssetImage(profilePictureUrl),
            ),
            const SizedBox(
              width: 16,
            ),
            Column(
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
                  lastMessage,
                  style: mediumTS.copyWith(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  lastMessageTime,
                  style: mediumTS.copyWith(color: Colors.grey),
                ),
                messageUnread > 0
                    ? CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.red,
                        child: Text(
                          '$messageUnread',
                          style: semiboldTS.copyWith(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        radius: 10,
                        backgroundColor: Colors.transparent,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
