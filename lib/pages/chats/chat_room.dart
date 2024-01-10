import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/chat_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/pages/chats/widgets/message_card.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRoom extends StatefulWidget {
  final ChatRoomModel model;
  const ChatRoom({super.key, required this.model});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
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
                      Text(
                        '@${widget.model.interlocutor!.username.toString()}',
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
                                  return MessageIn(model: chat);
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
