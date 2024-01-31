import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/pages/profile/profile.dart';
import 'package:convo/services/zego_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/user/user_bloc.dart';
import '../config/theme.dart';
import '../services/user_services.dart';
import '../widgets/default_avatar.dart';
import 'auth/login.dart';
import 'call/call_home.dart';
import 'chat/chat_home.dart';
import 'group/group_home.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // Update user online status for first time
    UserService().updateOnlineStatus(true);

    // Set listener to user online status
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        UserService().updateOnlineStatus(true);
      } else {
        UserService().updateOnlineStatus(false);
      }
      return Future.value(message);
    });

    // Init Zegocloud
    ZegoService().initZego();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAuthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            PageTransition(
              child: const LoginPage(),
              type: PageTransitionType.fade,
            ),
            (route) => false,
          );
        }
      },
      child: SafeArea(
        child: DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome,',
                          style: regularTS.copyWith(fontSize: 14),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        BlocProvider(
                          create: (context) => UserBloc()..add(GetSelfDataEvent()),
                          child: BlocBuilder<UserBloc, UserState>(
                            builder: (context, state) {
                              return Text(
                                (state is UserGetDataSuccess) ? '${state.model.displayName} 👋' : 'Convo User 👋',
                                style: semiboldTS,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    BlocProvider(
                      create: (context) => UserBloc()..add(StreamUserDataEvent(user!.uid)),
                      child: BlocBuilder<UserBloc, UserState>(
                        builder: (context, state) {
                          if (state is UserStreamDataSuccess) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  PageTransition(
                                    child: const ProfilePage(),
                                    type: PageTransitionType.fade,
                                  ),
                                );
                              },
                              child: CachedNetworkImage(
                                imageUrl: state.model.profilePicture.toString(),
                                imageBuilder: (context, imageProvider) {
                                  return Hero(
                                    tag: state.model.profilePicture.toString(),
                                    child: DefaultAvatar(radius: 26, image: imageProvider),
                                  );
                                },
                                placeholder: (context, url) {
                                  return const DefaultAvatar(radius: 26);
                                },
                              ),
                            );
                          }
                          return const DefaultAvatar(radius: 26);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(20),
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
                    splashBorderRadius: BorderRadius.circular(100),
                    tabs: const [
                      Tab(text: 'Personal'),
                      Tab(text: 'Group'),
                      Tab(text: 'Calls'),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Expanded(
                  child: TabBarView(
                    children: [
                      HomePersonal(),
                      HomeGroup(),
                      HomeCall(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
