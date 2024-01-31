import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../config/theme.dart';
import '../../widgets/card_room.dart';
import '../../widgets/custom_button.dart';
import 'add/chat_search.dart';

class HomePersonal extends StatelessWidget {
  const HomePersonal({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ChatBloc()..add(GetChatListEvent()),
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
        onTap: () => Navigator.of(context).push(
          PageTransition(
            child: const SearchUser(),
            type: PageTransitionType.rightToLeft,
          ),
        ),
      ),
    );
  }
}
