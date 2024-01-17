import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:convo/models/message_model.dart';
import 'package:convo/services/chat_services.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageOut extends StatelessWidget {
  final GroupRoomModel? group;
  final MessageModel model;
  const MessageOut({super.key, required this.model, this.group});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onLongPress: () => messageDetails(context, model, false),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Image.asset(
                  'assets/icons/read.png',
                  scale: 2,
                  color: group != null
                      ? model.readAt.length == group!.members!.length
                          ? blue
                          : null
                      : model.readAt.isNotEmpty
                          ? blue
                          : null,
                ),
                const SizedBox(
                  height: 6,
                ),
                Text(
                  formatTimeForChat(model.sendAt),
                  style: regularTS.copyWith(fontSize: 12),
                )
              ],
            ),
            const SizedBox(
              width: 12,
            ),
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
                      onTap: () => clickImage(context, model),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: model.image,
                          placeholder: (context, url) => const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Clipboard.setData(
                          ClipboardData(text: model.message),
                        ).then((_) {
                          showSnackbar(context, 'Text copied!');
                        });
                      },
                      child: Text(
                        model.message,
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
    if (model.readAt.isEmpty) {
      ChatService().updateUnread(model);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        onLongPress: () => messageDetails(context, model, true),
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
                    Column(
                      children: [
                        FutureBuilder(
                          future: UserService().getUserData(model.sendBy),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!.displayName.toString(),
                                style: semiboldTS.copyWith(color: blue),
                              );
                            }
                            return Text(
                              'Member',
                              style: semiboldTS.copyWith(color: blue),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                      ],
                    ),
                  model.image != ''
                      ? GestureDetector(
                          onTap: () => clickImage(context, model),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: model.image,
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
                              ClipboardData(text: model.message),
                            ).then((_) {
                              showSnackbar(context, 'Text copied!');
                            });
                          },
                          child: Text(
                            model.message,
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
              formatTimeForChat(model.sendAt),
              style: regularTS.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

void clickImage(BuildContext context, MessageModel model) {
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: model.image,
                  placeholder: (context, url) => const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              BlocProvider(
                create: (context) => ChatBloc(),
                child: BlocConsumer<ChatBloc, ChatState>(
                  listener: (context, state) {
                    if (state is ChatSuccess) {
                      showSnackbar(context, 'Image saved!');
                    }

                    if (state is ChatError) {
                      showSnackbar(context, state.e);
                    }
                  },
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const LoadingButton();
                    }
                    return CustomButton(
                      title: 'Save Image',
                      action: () {
                        context
                            .read<ChatBloc>()
                            .add(SaveImageEvent(model.image));
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      });
}

void messageDetails(BuildContext context, MessageModel model, bool received) {
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
              FutureBuilder(
                future: UserService().getUserData(model.sendBy),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      '${snapshot.data!.displayName.toString()} at ${formatTimeForChat(model.sendAt)}',
                      style: mediumTS,
                    );
                  }
                  return const Text('');
                },
              ),
              const SizedBox(
                height: 16,
              ),
              Text(
                'Read by ${model.readBy.isEmpty ? 'none' : ''}',
                style: regularTS,
              ),
              ...List.generate(model.readBy.length, (index) {
                return FutureBuilder(
                  future: UserService().getUserData(model.readBy[index]),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data!.displayName.toString()} at ${formatTimeForChat(model.readAt[index])}',
                        style: mediumTS,
                      );
                    }
                    return const Text('');
                  },
                );
              }),
              const SizedBox(
                height: 30,
              ),
              !received
                  ? Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            title: 'Delete for Me',
                            titleSize: 14,
                            padding: 12,
                            invert: true,
                            action: () {
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
                            action: () {
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
                      action: () {
                        ChatService().deleteMessageForMe(model);
                        Navigator.pop(context);
                      },
                    ),
            ],
          ),
        );
      });
}
