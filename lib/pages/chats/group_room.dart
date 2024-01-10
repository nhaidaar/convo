import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/chat_model.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:convo/pages/chats/widgets/message_card.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupRoom extends StatefulWidget {
  final GroupRoomModel model;
  const GroupRoom({super.key, required this.model});

  @override
  State<GroupRoom> createState() => _GroupRoomState();
}

class _GroupRoomState extends State<GroupRoom> {
  final user = FirebaseAuth.instance.currentUser;
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  @override
  void dispose() {
    messageController.dispose();
    messageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new),
          ),
          title: SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        widget.model.interlocutors!
                            .map((user) => user.displayName)
                            .join(', '),
                        style: semiboldTS.copyWith(fontSize: 18),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${widget.model.interlocutors!.length + 1} members',
                        style: mediumTS.copyWith(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {},
                icon: Image.asset(
                  'assets/icons/home_call.png',
                  scale: 2,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.grey[100],
        body: BlocProvider(
          create: (context) => ChatBloc()
            ..add(
              GetAllMessageEvent(widget.model.roomId!),
            ),
          child: Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is GetAllMessageSuccess) {
                      return SingleChildScrollView(
                        reverse: true,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: state.data.map(
                              (chat) {
                                if (chat.sendBy != user!.uid) {
                                  return GroupMessageIn(model: chat);
                                }
                                return MessageOut(model: chat);
                              },
                            ).toList(),
                          ),
                        ),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: blue,
                      ),
                    );
                  },
                ),
              ),
              BottomAppBar(
                elevation: 0,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomRoundField(
                        controller: messageController,
                        focusNode: messageFocus,
                        fillColor: Colors.grey[100],
                        hintText: 'Type something...',
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    GestureDetector(
                      onTap: () {
                        context.read<ChatBloc>().add(
                              SendMessageEvent(
                                roomId: widget.model.roomId.toString(),
                                message: ChatModel(
                                  message: messageController.text,
                                  sendAt: DateTime.now(),
                                  sendBy: user!.uid,
                                ),
                              ),
                            );
                        messageFocus.unfocus();
                        messageController.clear();
                      },
                      child: Image.asset(
                        'assets/icons/send.png',
                        scale: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // bottomNavigationBar:
        ),
      ),
    );
  }
}