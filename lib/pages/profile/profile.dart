import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()
        ..add(
          GetUserDataEvent(FirebaseAuth.instance.currentUser!.uid),
        ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserGetDataSuccess) {
            return Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Column(
                    children: [
                      Container(
                        height: 160,
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          image: DecorationImage(
                            image: NetworkImage(
                                state.model.profilePicture.toString()),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.grey.shade300,
                        ),
                      ),
                      Text(
                        state.model.displayName.toString(),
                        style: semiboldTS.copyWith(fontSize: 24, height: 2),
                      ),
                      Text(
                        '@${state.model.username.toString()}',
                        style:
                            mediumTS.copyWith(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ListTile(
                    onTap: () => showSnackbar(context, 'message'),
                    leading: const Icon(Icons.edit),
                    title: Text(
                      'Edit Profile',
                      style: mediumTS.copyWith(fontSize: 18),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  ListTile(
                    onTap: () {
                      context.read<AuthBloc>().add(SignOutEvent());
                    },
                    leading: const Icon(Icons.logout),
                    title: Text(
                      'Log out',
                      style: mediumTS.copyWith(fontSize: 18),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(color: blue),
          );
        },
      ),
    );
  }
}
