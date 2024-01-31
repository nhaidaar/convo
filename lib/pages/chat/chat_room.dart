import 'dart:io';

import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/message_model.dart';
import 'package:convo/models/chatroom_model.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/chat/chat_member.dart';
import 'package:convo/services/zego_services.dart';
import 'package:convo/widgets/call_button.dart';
import 'package:convo/widgets/card_chatuser.dart';
import 'package:convo/widgets/card_message.dart';
import 'package:convo/services/chat_services.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../services/user_services.dart';
import '../../widgets/default_leading.dart';

class ChatRoom extends StatefulWidget {
  final ChatRoomModel model;
  const ChatRoom({super.key, required this.model});

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final user = FirebaseAuth.instance.currentUser;
  final messageController = TextEditingController();
  final messageFocus = FocusNode();

  UserModel userModel = UserModel();
  String resourceId = 'convo_call';

  @override
  void initState() {
    getResourceId();
    getUserModel();
    super.initState();
  }

  @override
  void dispose() {
    messageController.dispose();
    messageFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => messageFocus.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: const DefaultLeading(),
            leadingWidth: 30,
            title: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  PageTransition(
                    child: ChatMember(model: widget.model),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              child: BlocProvider(
                create: (context) => UserBloc()..add(StreamUserDataEvent(widget.model.members![0])),
                child: BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserStreamDataSuccess) {
                      return ChatUserCard(
                        imageCondition: state.model.profilePicture.toString().isNotEmpty,
                        imageUrl: state.model.profilePicture.toString(),
                        title: state.model.displayName.toString(),
                        subtitle: state.model.isOnline!
                            ? 'Online'
                            : getLastActiveTime(
                                context: context,
                                lastActive: state.model.lastActive.toString(),
                              ),
                      );
                    }
                    return const DefaultChatUserCard();
                  },
                ),
              ),
            ),
            actions: [
              CallButton(
                resourceId: resourceId,
                id: [userModel.uid.toString()],
                name: [userModel.displayName.toString()],
              ),
              CallButton(
                isVideoCall: true,
                resourceId: resourceId,
                id: [userModel.uid.toString()],
                name: [userModel.displayName.toString()],
              ),
            ],
          ),
          backgroundColor: Colors.grey[100],
          body: BlocProvider(
            create: (context) => ChatBloc()..add(GetAllMessageEvent(widget.model.roomId!)),
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
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: MessageField(
                              controller: messageController,
                              focusNode: messageFocus,
                              onFieldSubmitted: (value) {
                                if (value!.isNotEmpty) {
                                  handleSendMessage(isImage: false);
                                }
                                messageFocus.requestFocus();
                              },
                              cameraOnTap: () async {
                                final image = await pickCamera();
                                final time = DateTime.now().millisecondsSinceEpoch.toString();

                                if (image != null) {
                                  await ChatService()
                                      .uploadChatImage(uid: user!.uid, name: time, image: File(image.path))
                                      .then((imageUrl) => handleSendMessage(isImage: true, imageUrl: imageUrl));
                                }
                              },
                              imageOnTap: () async {
                                final images = await pickMultiImage();
                                final time = DateTime.now().millisecondsSinceEpoch.toString();

                                for (var image in images) {
                                  await ChatService()
                                      .uploadChatImage(uid: user!.uid, name: time, image: File(image.path))
                                      .then((imageUrl) => handleSendMessage(isImage: true, imageUrl: imageUrl));
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          GestureDetector(
                            onTap: () {
                              if (messageController.text.isNotEmpty) {
                                handleSendMessage(isImage: false);
                              }
                            },
                            child: Image.asset(
                              'assets/icons/send.png',
                              scale: 2,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // bottomNavigationBar:
          ),
        ),
      ),
    );
  }

  void handleSendMessage({required bool isImage, String? imageUrl}) {
    context.read<ChatBloc>().add(
          SendMessageEvent(
            roomId: widget.model.roomId.toString(),
            message: MessageModel(
              roomId: widget.model.roomId.toString(),
              message: isImage ? '' : messageController.text,
              image: isImage ? imageUrl : '',
              sendBy: user!.uid,
              sendAt: DateTime.now().millisecondsSinceEpoch.toString(),
            ),
          ),
        );
    context.read<ChatBloc>().add(
          SendNotificationEvent(
            from: user!.uid,
            to: widget.model.members!,
            groupTitle: '',
            message: isImage ? '📷 Image' : messageController.text,
          ),
        );
    messageController.clear();
  }

  void getUserModel() {
    UserService().getUserData(widget.model.members![0]).then((value) {
      if (value != null) {
        setState(() => userModel = value);
      }
    });
  }

  void getResourceId() {
    ZegoService().getResourceId().then((value) {
      if (value != null) {
        setState(() => resourceId = value);
      }
    });
  }
}
