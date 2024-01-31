import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../config/method.dart';
import '../../config/theme.dart';
import '../../models/grouproom_model.dart';
import '../../widgets/card_member.dart';
import '../../widgets/default_leading.dart';
import '../home.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/default_avatar.dart';

import '../chat/chat_room.dart';

class GroupMember extends StatefulWidget {
  final GroupRoomModel model;
  const GroupMember({super.key, required this.model});

  @override
  State<GroupMember> createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMember> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => ChatBloc(),
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is MakeChatRoomSuccess) {
              Navigator.of(context).push(
                PageTransition(
                  child: ChatRoom(model: state.data),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            }

            if (state is ChatSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  child: const Home(),
                  type: PageTransitionType.leftToRight,
                ),
                (route) => false,
              );
              showSnackbar(context, "You've left '${widget.model.title}' group !");
            }

            if (state is ChatError) {
              showSnackbar(context, state.e);
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: const DefaultLeading(),
            ),
            extendBodyBehindAppBar: true,
            body: ListView(
              padding: const EdgeInsets.all(30),
              children: [
                Column(
                  children: [
                    Hero(
                      tag: widget.model.groupPicture.toString(),
                      child: GestureDetector(
                        onTap: () => clickImage(context, imageUrl: widget.model.groupPicture.toString()),
                        child: CachedNetworkImage(
                          imageUrl: widget.model.groupPicture.toString(),
                          imageBuilder: (context, imageProvider) {
                            return DefaultAvatar(
                              radius: 80,
                              image: imageProvider,
                            );
                          },
                          placeholder: (context, url) {
                            return const DefaultAvatar(radius: 80);
                          },
                        ),
                      ),
                    ),
                    Text(
                      widget.model.title.toString(),
                      style: semiboldTS.copyWith(fontSize: 24, height: 2),
                    ),
                    Text(
                      '${widget.model.members!.length + 1} members',
                      style: mediumTS.copyWith(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Members',
                  style: semiboldTS,
                ),
                const SizedBox(
                  height: 16,
                ),

                // Me
                BlocProvider(
                  create: (context) => UserBloc()..add(GetUserDataEvent(user!.uid)),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserGetDataSuccess) {
                        return MemberCard(
                          model: state.model,
                          isAdmin: state.model.uid == widget.model.admin,
                          isYou: true,
                        );
                      }
                      return Center(
                        child: CircularProgressIndicator(color: blue),
                      );
                    },
                  ),
                ),

                // Other Member
                ...List.generate(
                  widget.model.members!.length,
                  (index) {
                    return BlocProvider(
                      create: (context) => UserBloc()..add(GetUserDataEvent(widget.model.members![index])),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserGetDataSuccess) {
                            return MemberCard(
                              model: state.model,
                              isAdmin: state.model.uid == widget.model.admin,
                              onTap: () {
                                BlocProvider.of<ChatBloc>(context).add(
                                  MakeChatRoomEvent(
                                    myUid: user!.uid,
                                    friendUid: state.model.uid.toString(),
                                  ),
                                );
                              },
                            );
                          }
                          return Container();
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const LoadingButton(
                        buttonColor: Colors.red,
                      );
                    }
                    return ButtonWithIcon(
                      iconUrl: 'assets/icons/logout.png',
                      title: 'Leave from Group',
                      buttonColor: Colors.red,
                      onTap: () {
                        handleLeaveGroup(context);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleLeaveGroup(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            title: Text(
              'Leave from Group',
              style: semiboldTS,
              textAlign: TextAlign.center,
            ),
            content: Text.rich(
              TextSpan(
                text: 'Warning! ',
                style: mediumTS.copyWith(color: Colors.red),
                children: [
                  TextSpan(
                    text: 'You will no longer receive messages and updates from this group.',
                    style: regularTS.copyWith(color: Colors.black),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            actionsPadding: const EdgeInsets.all(20),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      title: 'Leave',
                      buttonColor: Colors.red,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<ChatBloc>().add(LeaveGroupEvent(widget.model.roomId.toString()));
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: CustomButton(
                      title: 'Nevermind',
                      buttonColor: Colors.red,
                      invert: true,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              ),
            ],
          );
        });
  }
}
