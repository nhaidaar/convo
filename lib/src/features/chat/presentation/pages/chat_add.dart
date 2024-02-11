import 'package:convo/src/features/chat/domain/bloc/chat_bloc.dart';
import 'package:convo/src/common/blocs/user_bloc.dart';
import 'package:convo/src/utils/method.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/features/chat/presentation/pages/chat_room.dart';
import 'package:convo/src/features/chat/presentation/widgets/card_searchmember.dart';
import 'package:convo/src/common/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../../common/widgets/default_leading.dart';

class ChatAdd extends StatefulWidget {
  const ChatAdd({super.key});

  @override
  State<ChatAdd> createState() => _ChatAddState();
}

class _ChatAddState extends State<ChatAdd> {
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => UserBloc(),
          ),
          BlocProvider(
            create: (context) => ChatBloc(),
          ),
        ],
        child: BlocListener<ChatBloc, ChatState>(
          listener: (context, state) async {
            if (state is MakeChatRoomSuccess) {
              Navigator.of(context).push(
                PageTransition(
                  child: ChatRoom(model: state.data),
                  type: PageTransitionType.rightToLeft,
                ),
              );
            }

            if (state is ChatError) {
              showSnackbar(context, state.e);
            }
          },
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              return Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Start New Chat',
                    style: semiboldTS,
                  ),
                  centerTitle: true,
                  leading: const DefaultLeading(),
                ),
                body: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  children: [
                    Text(
                      'Search by Username',
                      style: mediumTS.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomRoundField(
                      onFieldSubmitted: (value) {
                        if (value!.isNotEmpty) {
                          BlocProvider.of<UserBloc>(context).add(
                            SearchUserEvent(
                              search: cleanUsernameSearch(value),
                              exceptUid: currentUser!.uid,
                            ),
                          );
                        }
                      },
                      prefixIconUrl: 'assets/icons/search.png',
                      fillColor: Colors.grey.shade100,
                      borderColor: Colors.grey.shade400,
                      hintText: '@johndoe',
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      (state is UserSearchSuccess || state is UserLoading) ? 'Search Result' : '',
                      style: mediumTS.copyWith(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    (state is UserSearchSuccess)
                        ? state.userList.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  'User Not Found',
                                  style: regularTS,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : Column(
                                children: state.userList.map((user) {
                                  return SearchCard(
                                    model: user,
                                    onTap: () {
                                      BlocProvider.of<ChatBloc>(context).add(
                                        MakeChatRoomEvent(
                                          myUid: currentUser!.uid,
                                          friendUid: user.uid.toString(),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              )
                        : (state is UserLoading)
                            ? Center(
                                child: CircularProgressIndicator(color: blue),
                              )
                            : Container(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
