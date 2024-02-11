import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/src/features/chat/domain/bloc/chat_bloc.dart';
import 'package:convo/src/common/blocs/user_bloc.dart';
import 'package:convo/src/utils/method.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/features/chat/domain/models/chatroom_model.dart';
import 'package:convo/src/features/chat/presentation/pages/chat_room.dart';
import 'package:convo/src/common/widgets/default_avatar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../chat/domain/models/grouproom_model.dart';
import '../../../chat/presentation/pages/group_room.dart';

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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc()..add(GetLastMessageEvent(widget.model.roomId!)),
        ),
        BlocProvider(
          create: (context) => UserBloc()..add(StreamUserDataEvent(widget.model.members![0])),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
              child: ChatRoom(model: widget.model),
              type: PageTransitionType.rightToLeft,
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
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  if (state is UserStreamDataSuccess) {
                    return CachedNetworkImage(
                      imageUrl: state.model.profilePicture!,
                      imageBuilder: (context, imageProvider) {
                        return DefaultAvatar(
                          image: imageProvider,
                        );
                      },
                      placeholder: (context, url) {
                        return const DefaultAvatar();
                      },
                    );
                  }
                  return const DefaultAvatar();
                },
              ),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Contact Name
                    BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        return Text(
                          (state is UserStreamDataSuccess) ? state.model.displayName! : '',
                          style: semiboldTS.copyWith(fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        );
                      },
                    ),

                    // Last Message
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is GetLastMessageSuccess) {
                          return Row(
                            children: [
                              if (state.data.sendBy == user!.uid)
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/icons/read.png',
                                      scale: 2,
                                      color: state.data.readAt!.isNotEmpty ? blue : null,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                  ],
                                ),
                              Text(
                                state.data.image.toString().isNotEmpty ? '\t📷 Image' : state.data.message.toString(),
                                style: mediumTS.copyWith(fontSize: 15, color: Colors.grey),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        }
                        return const Text('');
                      },
                    ),
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
                  // Time of Last Message Sent
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is GetLastMessageSuccess) {
                        return Text(
                          formatTimeForLastMessage(state.data.sendAt.toString()),
                          style: mediumTS.copyWith(color: Colors.grey),
                        );
                      }
                      return const Text('');
                    },
                  ),

                  // Count of Unread Message
                  BlocProvider(
                    create: (context) => ChatBloc()..add(GetUnreadMessageEvent(widget.model.roomId!)),
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is GetUnreadMessageSuccess && state.data > 0) {
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
        ),
      ),
    );
  }
}

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
      create: (context) => ChatBloc()..add(GetLastMessageEvent(widget.model.roomId!)),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            PageTransition(
              child: GroupRoom(model: widget.model),
              type: PageTransitionType.rightToLeft,
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
              // Group Picture
              widget.model.groupPicture.toString().isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.model.groupPicture.toString(),
                      imageBuilder: (context, imageProvider) {
                        return DefaultAvatar(image: imageProvider);
                      },
                      placeholder: (context, url) {
                        return const DefaultAvatar();
                      },
                    )
                  : const DefaultAvatar(),
              const SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Group Name
                    Text(
                      widget.model.title.toString(),
                      style: semiboldTS.copyWith(fontSize: 18),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    // Last Message (Sender Name + Message)
                    BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is GetLastMessageSuccess) {
                          final message = state.data;

                          // Get the Sender Data
                          return BlocProvider(
                            create: (context) => UserBloc()..add(GetUserDataEvent(message.sendBy.toString())),
                            child: BlocBuilder<UserBloc, UserState>(
                              builder: (context, state) {
                                if (state is UserGetDataSuccess) {
                                  final sender = state.model;
                                  return Row(
                                    children: [
                                      if (message.sendBy == user!.uid)
                                        Row(
                                          children: [
                                            Image.asset(
                                              'assets/icons/read.png',
                                              scale: 2,
                                              color: message.readAt!.length == widget.model.members!.length ? blue : null,
                                            ),
                                            const SizedBox(
                                              width: 4,
                                            ),
                                          ],
                                        ),
                                      Text(
                                        // Sender Name
                                        (message.sendBy == user!.uid ? 'Me: ' : '${sender.displayName}: ') +
                                            // Message
                                            (message.image.toString().isNotEmpty ? '\t📷 Image' : message.message.toString()),
                                        style: mediumTS.copyWith(fontSize: 15, color: Colors.grey),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          );
                        }
                        return const Text('');
                      },
                    )
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
                  // Time of Last Message Sent
                  BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is GetLastMessageSuccess) {
                        return Text(
                          formatTimeForLastMessage(state.data.sendAt.toString()),
                          style: mediumTS.copyWith(color: Colors.grey),
                        );
                      }
                      return const Text('');
                    },
                  ),

                  // Count of Unread Message
                  BlocProvider(
                    create: (context) => ChatBloc()..add(GetUnreadMessageEvent(widget.model.roomId!)),
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is GetUnreadMessageSuccess && state.data > 0) {
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
        ),
      ),
    );
  }
}
