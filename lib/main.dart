import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

import 'src/features/auth/bloc/auth_bloc.dart';
import 'src/features/call/bloc/call_bloc.dart';
import 'src/features/chat/domain/bloc/chat_bloc.dart';
import 'src/common/blocs/user_bloc.dart';
import 'config/firebase_options.dart';
import 'src/common/models/user_model.dart';
import 'src/features/auth/presentation/pages/login.dart';
import 'src/features/auth/presentation/pages/set_profile.dart';
import 'src/features/home/presentation/pages/home.dart';
import 'src/features/auth/domain/repositories/auth_repository.dart';

final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set statusbar style
  _setSystemUIOverlayStyle();

  // Init Firebase Service
  await _initFirebase();
  // Init Notification Channel
  await _initNotificationChannel();

  // Init ZegoCloud
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);
  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  const MyApp({super.key, required this.navigatorKey});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
              auth: RepositoryProvider.of<AuthRepository>(context),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(),
          ),
          BlocProvider(
            create: (context) => UserBloc(),
          ),
          BlocProvider(
            create: (context) => CallBloc(),
          ),
        ],
        child: MaterialApp(
          navigatorKey: widget.navigatorKey,
          title: 'Convo',
          theme: ThemeData(
            fontFamily: 'SFProDisplay',
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: _appBarTheme(),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData) {
                return BlocProvider(
                  create: (context) => UserBloc()..add(GetUserDataEvent(userSnapshot.data!.uid)),
                  child: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      if (state is UserError) {
                        return SetProfilePage(
                          model: UserModel(
                            uid: userSnapshot.data!.uid,
                            credentials: userSnapshot.data!.phoneNumber ?? userSnapshot.data!.email,
                          ),
                        );
                      }
                      return const Home();
                    },
                  ),
                );
              }
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }

  AppBarTheme _appBarTheme() {
    return const AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      toolbarHeight: 90,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

void _setSystemUIOverlayStyle() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
}

Future<void> _initFirebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> _initNotificationChannel() async {
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
}
