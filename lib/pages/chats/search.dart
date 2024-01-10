import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/chats/chat_room.dart';
import 'package:convo/pages/chats/widgets/search_card.dart';
import 'package:convo/services/chat_services.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class SearchUser extends StatefulWidget {
  const SearchUser({super.key});

  @override
  State<SearchUser> createState() => _SearchUserState();
}

class _SearchUserState extends State<SearchUser> {
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
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: ChatRoom(model: state.data),
                  type: PageTransitionType.rightToLeft,
                ),
              );
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
                  leading: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                  ),
                ),
                body: ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
                          BlocProvider.of<UserBloc>(context)
                              .add(SearchUserEvent(
                            search:
                                value.replaceAll(RegExp(r'[^a-zA-Z0-9]'), ''),
                            exceptUid: currentUser!.uid,
                          ));
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
                      (state is UserSearchSuccess || state is UserLoading)
                          ? 'Search Result'
                          : '',
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
                                      action: () async {
                                        await ChatService()
                                            .isChatRoomExists(
                                                myUid: currentUser!.uid,
                                                interlocutorUid: user.uid!)
                                            .then((value) {
                                          value == null
                                              ? BlocProvider.of<ChatBloc>(
                                                      context)
                                                  .add(
                                                  MakeChatRoomEvent(
                                                      myUid: currentUser!.uid,
                                                      interlocutorUid:
                                                          user.uid.toString()),
                                                )
                                              : Navigator.push(
                                                  context,
                                                  PageTransition(
                                                      child: ChatRoom(
                                                          model: value),
                                                      type: PageTransitionType
                                                          .rightToLeft),
                                                );
                                        });
                                      });
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
