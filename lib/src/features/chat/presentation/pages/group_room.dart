import 'dart:io';

import 'package:convo/src/features/chat/domain/bloc/chat_bloc.dart';
import 'package:convo/src/utils/method.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/features/chat/domain/models/message_model.dart';
import 'package:convo/src/features/chat/domain/models/grouproom_model.dart';
import 'package:convo/src/common/models/user_model.dart';
import 'package:convo/src/features/chat/presentation/pages/group_member.dart';
import 'package:convo/src/common/services/user_services.dart';
import 'package:convo/src/features/chat/presentation/widgets/card_chatuser.dart';
import 'package:convo/src/features/chat/presentation/widgets/card_message.dart';
import 'package:convo/src/features/chat/domain/services/chat_services.dart';
import 'package:convo/src/common/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../call/domain/services/zego_services.dart';
import '../../../../common/widgets/call_button.dart';
import '../../../../common/widgets/default_leading.dart';

class GroupRoom extends StatefulWidget {
  final GroupRoomModel model;
  const GroupRoom({super.key, required this.model});

  @override
  State<GroupRoom> createState() => _GroupRoomState();
}

class _GroupRoomState extends State<GroupRoom> {
  final user = FirebaseAuth.instance.currentUser;
  final messageController = TextEditingController();
  final messageFocus = FocusNode();

  List<UserModel> memberModel = [];
  String resourceId = 'convo_call';

  @override
  void initState() {
    getResourceId();
    getMemberModel();
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
                    child: GroupMember(model: widget.model),
                    type: PageTransitionType.fade,
                  ),
                );
              },
              child: ChatUserCard(
                imageCondition: widget.model.groupPicture.toString() != '',
                imageUrl: widget.model.groupPicture.toString(),
                title: widget.model.title.toString(),
                subtitle: '${memberModel.map((member) => member.displayName!).toList().join(', ')}, You',
              ),
            ),
            actions: [
              CallButton(
                resourceId: resourceId,
                id: memberModel.map((member) => member.uid!).toList(),
                name: memberModel.map((member) => member.displayName!).toList(),
              ),
              CallButton(
                isVideoCall: true,
                resourceId: resourceId,
                id: memberModel.map((member) => member.uid!).toList(),
                name: memberModel.map((member) => member.displayName!).toList(),
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
                                    return MessageIn(
                                      model: chat,
                                      group: widget.model,
                                    );
                                  }
                                  return MessageOut(
                                    model: chat,
                                    group: widget.model,
                                  );
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
            groupTitle: '@ ${widget.model.title}',
            message: isImage ? '📷 Image' : messageController.text,
          ),
        );
    messageController.clear();
  }

  void getMemberModel() {
    for (String uid in widget.model.members!) {
      UserService().getUserData(uid).then((value) {
        if (value != null) {
          memberModel.add(value);
          setState(() {});
        }
      });
    }
  }

  void getResourceId() {
    ZegoService().getResourceId().then((value) {
      if (value != null) {
        setState(() => resourceId = value);
      }
    });
  }
}
