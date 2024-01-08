import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/chats/widgets/chat_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
            BlocProvider(
              create: (context) => ChatBloc()
                ..add(
                  GetAllPersonalChatEvent(user!.uid),
                ),
              child: BlocBuilder<ChatBloc, ChatState>(
                builder: (context, state) {
                  if (state is GetAllChatSuccess) {
                    return ListView(
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
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                Center(child: Text('Coming Soon!')),
                // ChatCard(
                //   title: 'Nola Safyan',
                //   lastMessage: 'Dimanaaa',
                //   lastMessageTime: '19.07',
                //   profilePictureUrl: 'assets/images/female1.jpg',
                //   messageUnread: 8,
                // ),
                // ChatCard(
                //   title: 'Rayyan',
                //   lastMessage: 'Fal...',
                //   lastMessageTime: '19.03',
                //   profilePictureUrl: 'assets/images/male1.jpg',
                //   messageUnread: 1,
                // ),
                // ChatCard(
                //   title: 'Irsyad',
                //   lastMessage: 'Gas ae',
                //   lastMessageTime: '19.01',
                //   profilePictureUrl: 'assets/images/male1.jpg',
                //   messageUnread: 0,
                // ),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: blue,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
