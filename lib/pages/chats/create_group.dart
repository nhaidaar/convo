import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/chats/group_room.dart';
import 'package:convo/pages/chats/widgets/search_card.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  List<UserModel> members = [];
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
            if (state is MakeGroupRoomSuccess) {
              Navigator.pushReplacement(
                context,
                PageTransition(
                  child: GroupRoom(model: state.data),
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
                    'Create New Group',
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
                    (members.isNotEmpty)
                        ? Text(
                            'Selected Members',
                            style: mediumTS.copyWith(fontSize: 16),
                          )
                        : Container(),
                    (members.isNotEmpty)
                        ? const SizedBox(
                            height: 10,
                          )
                        : Container(),
                    SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                          members.length,
                          (index) {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey[100],
                              ),
                              child: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: members[index]
                                        .profilePicture
                                        .toString(),
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.transparent,
                                        foregroundImage: imageProvider,
                                      );
                                    },
                                    placeholder: (context, url) {
                                      return const CircleAvatar(
                                        radius: 20,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: AssetImage(
                                          'assets/images/profile.jpg',
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '@${members[index].username.toString()}',
                                    style: semiboldTS,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    (members.isNotEmpty)
                        ? const SizedBox(
                            height: 20,
                          )
                        : Container(),
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
                                    action: () {
                                      if (!members.contains(user)) {
                                        setState(() {
                                          members.add(user);
                                        });
                                      }
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
                bottomNavigationBar: BottomAppBar(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: CustomButton(
                      disabled: members.isEmpty,
                      action: () async {
                        if (members.isNotEmpty) {
                          final myData =
                              await UserService().getUserData(currentUser!.uid);
                          if (myData != null) {
                            members.add(myData);
                          }
                          // ignore: use_build_context_synchronously
                          BlocProvider.of<ChatBloc>(context).add(
                            MakeGroupRoomEvent(members),
                          );
                        }
                      },
                      title: 'Create',
                      // invert: true,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
