import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/chats/group_selectmember.dart';
import 'package:convo/pages/chats/search.dart';
import 'package:convo/pages/chats/widgets/chat_card.dart';
import 'package:convo/pages/chats/widgets/group_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 100,
          title: Container(
            margin: const EdgeInsets.symmetric(horizontal: 50),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: TabBar(
              labelStyle: semiboldTS.copyWith(fontSize: 15),
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(100)),
                color: blue,
              ),
              tabs: const [
                Tab(
                  text: 'Personal',
                ),
                Tab(
                  text: 'Group',
                )
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Scaffold(
              body: BlocProvider(
                create: (context) =>
                    ChatBloc()..add(GetChatListEvent(user!.uid)),
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is GetChatListSuccess) {
                      if (state.data.isEmpty) {
                        return Center(
                          child: Text(
                            'Welcome aboard!\nChat list is empty. Why not say hello?',
                            style: mediumTS,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: state.data.map((chatRoom) {
                          return ChatCard(model: chatRoom);
                        }).toList(),
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
              floatingActionButton: FloatingButton(
                icon: const Icon(Icons.add),
                action: () => Navigator.of(context).push(
                  PageTransition(
                    child: const SearchUser(),
                    type: PageTransitionType.rightToLeft,
                  ),
                ),
              ),
            ),
            Scaffold(
              body: BlocProvider(
                create: (context) =>
                    ChatBloc()..add(GetGroupListEvent(user!.uid)),
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is GetGroupListSuccess) {
                      if (state.data.isEmpty) {
                        return Center(
                          child: Text(
                            'It looks a bit empty here.\nStart a new group and invite friends to join!',
                            style: mediumTS,
                            textAlign: TextAlign.center,
                          ),
                        );
                      }
                      return ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: state.data.map((groupRoom) {
                          return GroupCard(model: groupRoom);
                        }).toList(),
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
              floatingActionButton: FloatingButton(
                icon: const Icon(Icons.group_add),
                action: () => Navigator.of(context).push(
                  PageTransition(
                    child: const CreateGroup(),
                    type: PageTransitionType.rightToLeft,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FloatingButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? action;
  const FloatingButton({
    super.key,
    required this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: action,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: blue,
      child: icon,
    );
  }
}
