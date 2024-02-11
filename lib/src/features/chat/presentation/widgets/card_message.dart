import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/src/utils/method.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/features/chat/domain/models/grouproom_model.dart';
import 'package:convo/src/features/chat/domain/models/message_model.dart';
import 'package:convo/src/features/chat/domain/services/chat_services.dart';
import 'package:convo/src/common/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../common/blocs/user_bloc.dart';

class MessageOut extends StatelessWidget {
  final GroupRoomModel? group;
  final MessageModel model;
  const MessageOut({super.key, required this.model, this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onLongPress: () => messageDetails(context, model: model, isReceived: false),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Read tick
                Image.asset(
                  'assets/icons/read.png',
                  scale: 2,
                  color:
                      // Group Chat
                      group != null
                          // Are all members read the chat?
                          ? model.readAt!.length == group!.members!.length
                              ? blue
                              : null
                          // Personal Chat
                          : model.readAt!.isNotEmpty
                              ? blue
                              : null,
                ),
                const SizedBox(
                  height: 6,
                ),

                // Time of Message
                Text(
                  formatTimeForChat(model.sendAt.toString()),
                  style: regularTS.copyWith(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              width: 12,
            ),

            // Message Box
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(20),
                ),
                color: blue,
              ),
              child: model.image != ''
                  ? GestureDetector(
                      onTap: () => clickImage(context, imageUrl: model.image.toString()),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: model.image.toString(),
                          placeholder: (context, url) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(color: Colors.white),
                            );
                          },
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // Copy the text when user click it
                        Clipboard.setData(
                          ClipboardData(text: model.message.toString()),
                        ).then((_) {
                          showSnackbar(context, 'Text copied!');
                        });
                      },
                      child: Text(
                        model.message.toString(),
                        style: regularTS.copyWith(color: Colors.white),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageIn extends StatelessWidget {
  final MessageModel model;
  final GroupRoomModel? group;
  const MessageIn({super.key, required this.model, this.group});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (!model.readBy!.contains(user!.uid)) {
      ChatService().updateUnread(model);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onLongPress: () => messageDetails(context, model: model, isReceived: true),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width / 2,
              ),
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(15),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (group != null)
                    // Sender Name
                    Column(
                      children: [
                        BlocProvider(
                          create: (context) => UserBloc()..add(GetUserDataEvent(model.sendBy.toString())),
                          child: BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              return Text(
                                (state is UserGetDataSuccess) ? state.model.displayName.toString() : 'Member',
                                style: semiboldTS.copyWith(color: blue),
                              );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  model.image != ''
                      ? GestureDetector(
                          onTap: () => clickImage(context, imageUrl: model.image.toString()),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: model.image.toString(),
                              placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(
                                  color: blue,
                                ),
                              ),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () {
                            Clipboard.setData(
                              ClipboardData(text: model.message.toString()),
                            ).then((_) {
                              showSnackbar(context, 'Text copied!');
                            });
                          },
                          child: Text(
                            model.message.toString(),
                            style: regularTS,
                          ),
                        ),
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              formatTimeForChat(model.sendAt.toString()),
              style: regularTS.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

void messageDetails(
  BuildContext context, {
  required MessageModel model,
  required bool isReceived,
}) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          insetPadding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send by ',
                style: regularTS,
              ),
              BlocProvider(
                create: (context) => UserBloc()..add(GetUserDataEvent(model.sendBy.toString())),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserGetDataSuccess) {
                      return Text(
                        '${state.model.displayName.toString()} at ${formatTimeForChat(model.sendAt.toString())}',
                        style: mediumTS,
                      );
                    }
                    return const Text('');
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Read by ${model.readBy!.isEmpty ? 'none' : ''}',
                style: regularTS,
              ),
              ...List.generate(model.readBy!.length, (index) {
                return BlocProvider(
                  create: (context) => UserBloc()..add(GetUserDataEvent(model.readBy![index])),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserGetDataSuccess) {
                        return Text(
                          '${state.model.displayName.toString()} at ${formatTimeForChat(model.sendAt.toString())}',
                          style: mediumTS,
                        );
                      }
                      return const Text('');
                    },
                  ),
                );
              }),
              const SizedBox(
                height: 30,
              ),
              !isReceived
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: 'Delete for Me',
                            titleSize: 14,
                            padding: 12,
                            invert: true,
                            onTap: () {
                              ChatService().deleteMessageForMe(model);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomButton(
                            title: 'Delete for Everyone',
                            titleSize: 14,
                            padding: 12,
                            onTap: () {
                              ChatService().deleteMessageForEveryone(model);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    )
                  : CustomButton(
                      title: 'Delete for Me',
                      titleSize: 14,
                      padding: 12,
                      invert: true,
                      onTap: () {
                        ChatService().deleteMessageForMe(model);
                        Navigator.pop(context);
                      },
                    ),
            ],
          ),
        );
      });
}
