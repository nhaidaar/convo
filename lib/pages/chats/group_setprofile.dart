import 'dart:io';

import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/grouproom_model.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/chats/group_room.dart';
import 'package:convo/pages/chats/widgets/search_card.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class CreateGroupNext extends StatefulWidget {
  final List<UserModel> members;
  const CreateGroupNext({super.key, required this.members});

  @override
  State<CreateGroupNext> createState() => _CreateGroupNextState();
}

class _CreateGroupNextState extends State<CreateGroupNext> {
  final titleController = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;

  File? image;
  bool isTitleEmpty = true;

  @override
  void initState() {
    super.initState();
    titleController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    titleController.removeListener(updateFieldState);
    titleController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      isTitleEmpty = titleController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ChatBloc(),
        child: BlocConsumer<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is MakeGroupRoomSuccess) {
              Navigator.of(context).push(
                PageTransition(
                  child: GroupRoom(model: state.data),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            }

            if (state is ChatError) {
              showSnackbar(context, state.e);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'One Step Again',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                children: [
                  GestureDetector(
                    onTap: () async {
                      final picked = await pickImage();
                      if (picked != null) {
                        final cropped = await cropImage(picked);
                        if (cropped != null) {
                          setState(() {
                            image = File(cropped.path);
                          });
                        }
                      }
                    },
                    child: Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey.shade300,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            foregroundImage:
                                image != null ? FileImage(image!) : null,
                            child: Image.asset(
                              'assets/icons/add_photo.png',
                              scale: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                    'Group Name',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    controller: titleController,
                    keyboardType: TextInputType.name,
                    hintText: 'Sirkel ABC',
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    'You and ${widget.members.length} members',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ...widget.members.map(
                    (member) {
                      return SearchCard(
                        model: member,
                        showIcon: false,
                      );
                    },
                  ).toList(),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: CustomButton(
                    title: 'Create Group',
                    disabled: isTitleEmpty || image == null,
                    action: () async {
                      if (!isTitleEmpty && image != null) {
                        List<String> membersUid = [currentUser!.uid];

                        for (UserModel member in widget.members) {
                          if (member.uid != null) {
                            membersUid.add(member.uid.toString());
                          }
                        }

                        final groupRoom = GroupRoomModel(
                          roomId: '',
                          admin: currentUser!.uid,
                          members: membersUid,
                          title: titleController.text,
                          groupPicture: '',
                        );

                        BlocProvider.of<ChatBloc>(context).add(
                          MakeGroupRoomEvent(groupRoom, image!),
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
