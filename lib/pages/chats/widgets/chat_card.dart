import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/pages/chats/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatefulWidget {
  final ChatRoomModel model;
  const ChatCard({super.key, required this.model});

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatRoom(
              model: widget.model,
            ),
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
              backgroundImage: const AssetImage('assets/images/male1.jpg'),
              foregroundImage: NetworkImage(
                widget.model.interlocutor!.profilePicture.toString(),
              ),
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
                    widget.model.interlocutor!.displayName.toString(),
                    style: semiboldTS.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    (widget.model.lastMessage!.sendBy == user!.uid
                            ? 'Me: '
                            : '') +
                        widget.model.lastMessage!.message,
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
            formatDate(widget.model.lastMessage!.sendAt) != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        formatDate(widget.model.lastMessage!.sendAt),
                        style: mediumTS.copyWith(color: Colors.grey),
                      ),
                      Text(
                        formatTime(widget.model.lastMessage!.sendAt),
                        style: mediumTS.copyWith(color: Colors.grey),
                      ),
                    ],
                  )
                : Text(
                    formatTime(widget.model.lastMessage!.sendAt),
                    style: mediumTS.copyWith(color: Colors.grey),
                  ),
          ],
        ),
      ),
    );
  }
}
