import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/blocs/chat/chat_bloc.dart';
import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/firebase_options.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/auth/login.dart';
import 'package:convo/pages/auth/set_profile.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/repositories/auth_repository.dart';
import 'package:convo/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FlutterNotificationChannel.registerNotificationChannel(
    description: 'For Showing Message Notification',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
        ],
        child: MaterialApp(
          title: 'Convo',
          theme: ThemeData(
            fontFamily: 'SFProDisplay',
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              toolbarHeight: 90,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData) {
                return FutureBuilder(
                  future: UserService().isUserExists(userSnapshot.data!.uid),
                  builder: (context, dataSnapshot) {
                    if (dataSnapshot.hasData) {
                      if (!(dataSnapshot.data!)) {
                        return SetProfilePage(
                          model: UserModel(
                            uid: userSnapshot.data!.uid,
                            credentials: userSnapshot.data!.phoneNumber ??
                                userSnapshot.data!.email,
                          ),
                        );
                      }
                      return const Home();
                    }
                    return const Home();
                  },
                );
              }
              return const LoginPage();
            },
          ),
        ),
      ),
    );
  }
}
