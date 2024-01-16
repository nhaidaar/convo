import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:convo/pages/chats/group_room.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class GroupCard extends StatefulWidget {
  final GroupRoomModel model;
  const GroupCard({super.key, required this.model});

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatBloc()..add(GetLastMessageEvent(widget.model.roomId!)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
              child: GroupRoom(model: widget.model),
              type: PageTransitionType.rightToLeft,
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
                  widget.model.groupPicture != ''
                      ? CachedNetworkImage(
                          imageUrl: widget.model.groupPicture.toString(),
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
                        )
                      : const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.transparent,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpg',
                          ),
                        ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.model.title.toString(),
                          style: semiboldTS.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        (state is GetLastMessageSuccess)
                            ? Row(
                                children: [
                                  if (state.data.message.isNotEmpty ||
                                      state.data.image.isNotEmpty)
                                    Image.asset(
                                      'assets/icons/read.png',
                                      scale: 2,
                                      color: state.data.readAt.length ==
                                              widget.model.members!.length
                                          ? blue
                                          : null,
                                    ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    (state.data.sendBy == user!.uid
                                            ? 'Me: '
                                            : '') +
                                        (state.data.image != ''
                                            ? '\t📷 Image'
                                            : state.data.message),
                                    style: mediumTS.copyWith(
                                      fontSize: 15,
                                      color: Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<ChatBloc, ChatState>(
                        builder: (context, state) {
                          if (state is GetLastMessageSuccess) {
                            return Text(
                              formatTimeForLastMessage(state.data.sendAt),
                              style: mediumTS.copyWith(color: Colors.grey),
                            );
                          }
                          return const Text('');
                        },
                      ),
                      BlocProvider(
                        create: (context) => ChatBloc()
                          ..add(GetUnreadMessageEvent(widget.model.roomId!)),
                        child: BlocBuilder<ChatBloc, ChatState>(
                          builder: (context, state) {
                            if (state is GetUnreadMessageSuccess &&
                                state.data > 0) {
                              return CircleAvatar(
                                radius: 11,
                                backgroundColor: Colors.red,
                                child: Text(
                                  state.data.toString(),
                                  style: mediumTS.copyWith(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              );
                            }
                            return const Text('');
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
