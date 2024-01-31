import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../blocs/chat/chat_bloc.dart';
import '../../config/theme.dart';
import '../../widgets/card_room.dart';
import '../../widgets/custom_button.dart';
import 'add/group_selectmember.dart';

class HomeGroup extends StatelessWidget {
  const HomeGroup({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ChatBloc()..add(GetGroupListEvent()),
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
        onTap: () => Navigator.of(context).push(
          PageTransition(
            child: const CreateGroup(),
            type: PageTransitionType.rightToLeft,
          ),
        ),
      ),
    );
  }
}
