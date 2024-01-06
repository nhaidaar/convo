import 'package:convo/config/theme.dart';
import 'package:convo/pages/chats/widgets/chat_card.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

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
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                ChatCard(
                  title: 'Nola Safyan',
                  lastMessage: 'Dimanaaa',
                  lastMessageTime: '19.07',
                  profilePictureUrl: 'assets/images/female1.jpg',
                  messageUnread: 8,
                ),
                ChatCard(
                  title: 'Rayyan',
                  lastMessage: 'Fal...',
                  lastMessageTime: '19.03',
                  profilePictureUrl: 'assets/images/male1.jpg',
                  messageUnread: 1,
                ),
                ChatCard(
                  title: 'Irsyad',
                  lastMessage: 'Gas ae',
                  lastMessageTime: '19.01',
                  profilePictureUrl: 'assets/images/male1.jpg',
                  messageUnread: 0,
                ),
              ],
            ),
            ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: const [
                ChatCard(
                  title: 'Nola Safyan',
                  lastMessage: 'Dimanaaa',
                  lastMessageTime: '19.07',
                  profilePictureUrl: 'assets/images/female1.jpg',
                  messageUnread: 8,
                ),
                ChatCard(
                  title: 'Rayyan',
                  lastMessage: 'Fal...',
                  lastMessageTime: '19.03',
                  profilePictureUrl: 'assets/images/male1.jpg',
                  messageUnread: 1,
                ),
                ChatCard(
                  title: 'Irsyad',
                  lastMessage: 'Gas ae',
                  lastMessageTime: '19.01',
                  profilePictureUrl: 'assets/images/male1.jpg',
                  messageUnread: 0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
