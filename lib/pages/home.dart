import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/auth/login.dart';
import 'package:convo/pages/calls/call.dart';
import 'package:convo/pages/chats/chat_list.dart';
import 'package:convo/pages/profile/profile.dart';
import 'package:convo/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _pages = [
    const ChatPage(),
    const CallPage(),
    const ProfilePage(),
  ];
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    UserService().updateOnlineStatus(true);
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString().contains('resume')) {
        UserService().updateOnlineStatus(true);
      } else {
        UserService().updateOnlineStatus(false);
      }
      return Future.value(message);
    });
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
        child: Scaffold(
          body: _pages[_currentIndex],
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            height: 70,
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
              selectedItemColor: blue,
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/icons/home_chat.png'),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/icons/home_call.png'),
                  ),
                  label: 'Call',
                ),
                BottomNavigationBarItem(
                  icon: ImageIcon(
                    AssetImage('assets/icons/home_profile.png'),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
