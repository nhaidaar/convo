import 'package:convo/config/theme.dart';
import 'package:convo/pages/chats/widgets/message_card.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatelessWidget {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        title: SizedBox(
          height: 50,
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: blue,
                backgroundImage: const AssetImage('assets/images/male1.jpg'),
              ),
              const SizedBox(
                width: 16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Nola Safyan',
                    style: semiboldTS.copyWith(fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Online',
                    style: mediumTS.copyWith(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {},
              icon: Image.asset(
                'assets/icons/home_call.png',
                scale: 2,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              MessageOut(
                message:
                    'In nisi sunt amet qui cillum qui consectetur esse magna reprehenderit laborum commodo nisi. Sunt deserunt fugiat non nisi amet sunt Lorem dolore reprehenderit minim. Deserunt est dolore nulla et do reprehenderit labore et veniam voluptate ullamco consectetur duis. Esse minim fugiat quis consequat nisi do fugiat laboris. Pariatur quis ullamco est labore anim in adipisicing. Ullamco eiusmod ad anim ad incididunt laborum. Incididunt aliquip ut nulla tempor.',
              ),
              MessageIn(
                message:
                    'Velit ex tempor ea eiusmod duis et pariatur voluptate consectetur ipsum aute velit incididunt non. Aliqua nostrud nisi est ut quis cupidatat pariatur tempor do mollit proident consequat. Proident veniam magna cupidatat magna eiusmod ullamco officia sit fugiat culpa ipsum adipisicing reprehenderit.',
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: TextField(
            decoration: InputDecoration(
              fillColor: Colors.grey[100],
              filled: true,
              hintText: 'Type something...',
              contentPadding: const EdgeInsets.symmetric(horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              suffixIcon: Image.asset(
                'assets/icons/send.png',
                scale: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
