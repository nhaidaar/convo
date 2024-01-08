import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/firebase_options.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/auth/login_phone.dart';
import 'package:convo/pages/auth/set_profile.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/repositories/auth_repository.dart';
import 'package:convo/services/user_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider(
        create: (context) => AuthBloc(
          auth: RepositoryProvider.of<AuthRepository>(context),
        ),
        child: MaterialApp(
          theme: ThemeData(
            fontFamily: 'SFProDisplay',
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              toolbarHeight: 90,
            ),
          ),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasData) {
                return FutureBuilder(
                  future:
                      UserService().doesUserDataExists(userSnapshot.data!.uid),
                  builder: (context, dataSnapshot) {
                    if (dataSnapshot.data == true) {
                      return const Home();
                    }
                    return SetProfilePage(
                      model: UserModel(
                        uid: userSnapshot.data!.uid,
                        credentials: userSnapshot.data!.phoneNumber ??
                            userSnapshot.data!.email,
                      ),
                    );
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
