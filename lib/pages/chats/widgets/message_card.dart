import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/message_model.dart';
import 'package:convo/services/user_services.dart';
import 'package:flutter/material.dart';

class MessageOut extends StatelessWidget {
  final MessageModel model;
  const MessageOut({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                formatDate(model.sendAt),
                style: regularTS.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formatTime(model.sendAt),
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
            child: Text(
              model.message,
              style: regularTS.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageIn extends StatelessWidget {
  final MessageModel model;
  const MessageIn({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            child: Text(
              model.message,
              style: regularTS,
            ),
          ),
          const SizedBox(
            width: 12,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatDate(model.sendAt),
                style: regularTS.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formatTime(model.sendAt),
                style: regularTS.copyWith(fontSize: 12),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class GroupMessageIn extends StatelessWidget {
  final MessageModel model;
  const GroupMessageIn({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                Text(
                  model.message,
                  style: regularTS,
                ),
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
                formatDate(model.sendAt),
                style: regularTS.copyWith(fontSize: 12),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                formatTime(model.sendAt),
                style: regularTS.copyWith(fontSize: 12),
              )
            ],
          ),
        ],
      ),
    );
  }
}
