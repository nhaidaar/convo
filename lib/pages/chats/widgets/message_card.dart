import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/message_model.dart';
import 'package:convo/services/chat_services.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class MessageOut extends StatelessWidget {
  final MessageModel model;
  const MessageOut({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () => messageDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  model.readAt.isNotEmpty ? 'Read' : 'Unread',
                  style: mediumTS.copyWith(fontSize: 12),
                ),
                const SizedBox(
                  height: 4,
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
                  ? CachedNetworkImage(
                      imageUrl: model.image,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      model.message,
                      style: regularTS.copyWith(color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> messageDetails(BuildContext context) {
    return showDialog(
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
                Row(
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
              ],
            ),
          );
        });
  }
}

class MessageIn extends StatelessWidget {
  final MessageModel model;
  const MessageIn({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.readAt.isEmpty) {
      ChatService().updateUnread(model);
    }

    return GestureDetector(
      onLongPress: () => messageDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: model.image != ''
                  ? CachedNetworkImage(
                      imageUrl: model.image,
                      placeholder: (context, url) => CircularProgressIndicator(
                        color: blue,
                      ),
                    )
                  : Text(
                      model.message,
                      style: regularTS,
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

  Future<dynamic> messageDetails(BuildContext context) {
    return showDialog(
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
                CustomButton(
                  title: 'Delete for Me',
                  titleSize: 14,
                  padding: 12,
                  invert: true,
                  action: () {
                    ChatService().deleteMessageForMe(model);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }
}

class GroupMessageIn extends StatelessWidget {
  final MessageModel model;
  const GroupMessageIn({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    if (model.readAt.isEmpty) {
      ChatService().updateUnread(model);
    }

    return GestureDetector(
      onLongPress: () => messageDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
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
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    height: 4,
                  ),
                  model.image != ''
                      ? CachedNetworkImage(
                          imageUrl: model.image,
                          placeholder: (context, url) =>
                              CircularProgressIndicator(
                            color: blue,
                          ),
                        )
                      : Text(
                          model.message,
                          style: regularTS,
                        )
                ],
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatTimeForChat(model.sendAt),
                  style: regularTS.copyWith(fontSize: 12),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> messageDetails(BuildContext context) {
    return showDialog(
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
                CustomButton(
                  title: 'Delete for Me',
                  titleSize: 14,
                  padding: 12,
                  invert: true,
                  action: () {
                    ChatService().deleteMessageForMe(model);
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          );
        });
  }
}
