import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../../auth/bloc/auth_bloc.dart';
import '../../../../common/blocs/user_bloc.dart';
import '../../../../utils/method.dart';
import '../../../../constants/theme.dart';
import '../../../../common/services/user_services.dart';
import '../../../../common/widgets/custom_button.dart';
import '../../../../common/widgets/custom_listtile.dart';
import '../../../../common/widgets/default_avatar.dart';

import '../../../../common/widgets/default_leading.dart';
import 'change_password.dart';
import 'profile_edit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Your Profile',
            style: semiboldTS,
          ),
          centerTitle: true,
          leading: const DefaultLeading(),
        ),
        body: BlocProvider(
          create: (context) => UserBloc()..add(GetUserDataEvent(FirebaseAuth.instance.currentUser!.uid)),
          child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserGetDataSuccess) {
                return ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Column(
                      children: [
                        GestureDetector(
                          onTap: () => clickImage(context, imageUrl: state.model.profilePicture.toString()),
                          child: CachedNetworkImage(
                            imageUrl: state.model.profilePicture.toString(),
                            imageBuilder: (context, imageProvider) {
                              return Hero(
                                tag: state.model.profilePicture.toString(),
                                child: DefaultAvatar(
                                  radius: 80,
                                  image: imageProvider,
                                ),
                              );
                            },
                            placeholder: (context, url) {
                              return const DefaultAvatar(radius: 80);
                            },
                          ),
                        ),
                        Text(
                          state.model.displayName.toString(),
                          style: semiboldTS.copyWith(fontSize: 24, height: 2),
                        ),
                        Text(
                          '@${state.model.username.toString()}',
                          style: mediumTS.copyWith(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    CustomListTile(
                      title: 'Edit Profile',
                      iconUrl: 'assets/icons/edit.png',
                      onTap: () {
                        Navigator.of(context).push(
                          PageTransition(
                            child: EditProfilePage(user: state.model),
                            type: PageTransitionType.rightToLeft,
                          ),
                        );
                      },
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    if (!state.model.credentials!.startsWith('+'))
                      Column(
                        children: [
                          CustomListTile(
                            title: 'Change Password',
                            iconUrl: 'assets/icons/change_password.png',
                            onTap: () {
                              Navigator.of(context).push(
                                PageTransition(
                                  child: const ChangePasswordPage(),
                                  type: PageTransitionType.rightToLeft,
                                ),
                              );
                            },
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                    CustomListTile(
                      title: 'Log out',
                      iconUrl: 'assets/icons/logout.png',
                      onTap: () => handleLogout(context),
                      isRed: true,
                    ),
                  ],
                );
              }
              return Center(
                child: CircularProgressIndicator(color: blue),
              );
            },
          ),
        ),
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
                      title: 'Nevermind',
                      buttonColor: Colors.red,
                      invert: true,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: CustomButton(
                      title: 'Confirm',
                      buttonColor: Colors.red,
                      onTap: () async {
                        await UserService().updateOnlineStatus(false).then((_) {
                          context.read<AuthBloc>().add(SignOutEvent());
                        });
                      },
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
