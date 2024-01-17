import 'package:cached_network_image/cached_network_image.dart';
import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/profile/change_password.dart';
import 'package:convo/pages/profile/edit_profile.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()
        ..add(GetUserDataEvent(FirebaseAuth.instance.currentUser!.uid)),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserGetDataSuccess) {
            return Scaffold(
              body: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: state.model.profilePicture.toString(),
                        imageBuilder: (context, imageProvider) {
                          return Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                        placeholder: (context, url) {
                          return Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey.shade300,
                            ),
                          );
                        },
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
                    onTap: () => Navigator.of(context).push(
                      PageTransition(
                        child: EditProfilePage(user: state.model),
                        type: PageTransitionType.rightToLeft,
                      ),
                    ),
                    leading: const ImageIcon(
                      AssetImage('assets/icons/edit.png'),
                    ),
                    title: Text(
                      'Edit Profile',
                      style: mediumTS.copyWith(fontSize: 18),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                  if (!state.model.credentials!.startsWith('+'))
                    Column(
                      children: [
                        ListTile(
                          onTap: () => Navigator.of(context).push(
                            PageTransition(
                              child: const ChangePasswordPage(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          ),
                          leading: const ImageIcon(
                            AssetImage('assets/icons/change_password.png'),
                          ),
                          title: Text(
                            'Change Password',
                            style: mediumTS.copyWith(fontSize: 18),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(
                          thickness: 1,
                        ),
                      ],
                    ),
                  ListTile(
                    onTap: () {
                      handleLogout(context);
                    },
                    leading: const ImageIcon(
                      AssetImage('assets/icons/logout.png'),
                      color: Colors.red,
                    ),
                    title: Text(
                      'Log out',
                      style: mediumTS.copyWith(fontSize: 18, color: Colors.red),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.red,
                    ),
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

  void handleLogout(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              'Are you sure to logout?',
              style: semiboldTS,
              textAlign: TextAlign.center,
            ),
            titlePadding: const EdgeInsets.fromLTRB(30, 30, 30, 10),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      action: () => Navigator.pop(context),
                      title: 'Nevermind',
                      invert: true,
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: CustomButton(
                      action: () async {
                        await UserService().updateOnlineStatus(false);
                        // ignore: use_build_context_synchronously
                        context.read<AuthBloc>().add(SignOutEvent());
                      },
                      title: 'Confirm',
                    ),
                  ),
                ],
              ),
            ],
            actionsPadding: const EdgeInsets.all(20),
          );
        });
  }
}
