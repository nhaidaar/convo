import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/pages/chats/chat_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    return BlocProvider(
      create: (context) => ChatBloc()
        ..add(
          GetLastMessageEvent(widget.model.roomId!),
        ),
      child: GestureDetector(
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
        child: BlocBuilder<ChatBloc, ChatState>(
          builder: (context, state) {
            return Container(
              height: 90,
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.only(bottom: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[100],
              ),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl:
                        widget.model.interlocutor!.profilePicture.toString(),
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
                          widget.model.interlocutor!.displayName.toString(),
                          style: semiboldTS.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        (state is GetLastMessageSuccess)
                            ? Text(
                                (state.data.sendBy == user!.uid ? 'Me: ' : '') +
                                    state.data.message,
                                style: mediumTS.copyWith(
                                  fontSize: 15,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  (state is GetLastMessageSuccess)
                      ? (formatDate(state.data.sendAt) != ''
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  formatDate(state.data.sendAt),
                                  style: mediumTS.copyWith(color: Colors.grey),
                                ),
                                Text(
                                  formatTime(state.data.sendAt),
                                  style: mediumTS.copyWith(color: Colors.grey),
                                ),
                              ],
                            )
                          : Text(
                              formatTime(state.data.sendAt),
                              style: mediumTS.copyWith(color: Colors.grey),
                            ))
                      : const Text(''),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
