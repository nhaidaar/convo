import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../domain/bloc/chat_bloc.dart';
import '../../../../common/blocs/user_bloc.dart';
import '../../../../utils/method.dart';
import '../../../../constants/theme.dart';
import '../../domain/models/grouproom_model.dart';
import '../../domain/models/chatroom_model.dart';
import '../widgets/card_member.dart';
import '../../../../common/widgets/default_leading.dart';
import '../../../home/presentation/pages/home.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/default_avatar.dart';

import 'group_room.dart';

class ChatMember extends StatelessWidget {
  final ChatRoomModel model;
  const ChatMember({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc()..add(GetUserDataEvent(model.members![0])),
          ),
          BlocProvider(
            create: (context) => ChatBloc(),
          ),
        ],
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) {
            if (state is ChatSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  child: const Home(),
                  type: PageTransitionType.leftToRight,
                ),
                (route) => false,
              );
              showSnackbar(context, 'Chat deleted!');
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
                BlocBuilder<UserBloc, UserState>(
                  builder: (context, state) {
                    if (state is UserGetDataSuccess) {
                      return Column(
                        children: [
                          Hero(
                            tag: state.model.profilePicture.toString(),
                            child: GestureDetector(
                              onTap: () => clickImage(context, imageUrl: state.model.profilePicture.toString()),
                              child: CachedNetworkImage(
                                imageUrl: state.model.profilePicture.toString(),
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
                            state.model.displayName.toString(),
                            style: semiboldTS.copyWith(fontSize: 24, height: 2),
                          ),
                          Text(
                            '@${state.model.username.toString()}',
                            style: mediumTS.copyWith(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            state.model.isOnline!
                                ? 'Online'
                                : getLastActiveTime(context: context, lastActive: state.model.lastActive.toString()),
                            style: mediumTS.copyWith(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                BlocProvider(
                  create: (context) => ChatBloc()..add(GetSameGroupListEvent(model.members![0])),
                  child: BlocBuilder<ChatBloc, ChatState>(
                    builder: (context, state) {
                      if (state is GetGroupListSuccess) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Same group with you',
                              style: semiboldTS,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            ...state.data.map((GroupRoomModel group) {
                              return SameGroupCard(
                                model: group,
                                onTap: () {
                                  Navigator.of(context).push(
                                    PageTransition(
                                      child: GroupRoom(model: group),
                                      type: PageTransitionType.rightToLeft,
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        );
                      }
                      return Container();
                    },
                  ),
                ),
                BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const LoadingButton(
                        buttonColor: Colors.red,
                      );
                    }
                    return ButtonWithIcon(
                      iconUrl: 'assets/icons/trash.png',
                      title: 'Delete Chat',
                      buttonColor: Colors.red,
                      onTap: () {
                        handleDeleteChat(context);
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

  void handleDeleteChat(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            titlePadding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            title: Text(
              'Delete Chat',
              style: semiboldTS,
              textAlign: TextAlign.center,
            ),
            content: Text.rich(
              TextSpan(
                text: 'Warning! ',
                style: mediumTS.copyWith(color: Colors.red),
                children: [
                  TextSpan(
                    text: 'Keep in mind that it will be deleted not only from your device but also from the recipient\'s device.',
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
                      title: 'Delete',
                      buttonColor: Colors.red,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.read<ChatBloc>().add(DeleteChatEvent(model.roomId.toString()));
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
