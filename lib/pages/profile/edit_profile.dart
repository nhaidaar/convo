import 'dart:io';

import 'package:convo/blocs/user/user_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

import '../../widgets/default_leading.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final credentialController = TextEditingController();
  final displayNameController = TextEditingController();
  final usernameController = TextEditingController();

  String oldUsername = '';
  bool areFieldsEmpty = false;
  File? image;

  @override
  void initState() {
    credentialController.text = widget.user.credentials.toString();
    displayNameController.text = widget.user.displayName.toString();

    oldUsername = widget.user.username.toString();
    usernameController.text = oldUsername;

    super.initState();
    displayNameController.addListener(updateFieldState);
    usernameController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    displayNameController.removeListener(updateFieldState);
    usernameController.removeListener(updateFieldState);
    credentialController.dispose();
    displayNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      areFieldsEmpty = displayNameController.text.isEmpty || usernameController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => UserBloc(),
        child: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UsernameAvailable) {
              handleImageUpload(context);
            }

            if (state is UserStoreFileSuccess) {
              context.read<UserBloc>().add(
                    UpdateUserDataEvent(
                      widget.user.copyWith(
                        displayName: displayNameController.text,
                        username: usernameController.text,
                        profilePicture: state.url,
                      ),
                    ),
                  );
            }

            if (state is UserSuccess) {
              Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  child: const Home(),
                  type: PageTransitionType.leftToRight,
                ),
                (route) => false,
              );
              showSnackbar(context, 'Profile updated!');
            }

            if (state is UserError) {
              showSnackbar(context, state.e);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Edit Profile',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: const DefaultLeading(),
              ),
              body: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                children: [
                  Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey.shade300,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundColor: Colors.white,
                              backgroundImage: NetworkImage(
                                widget.user.profilePicture.toString(),
                              ),
                              foregroundImage: image != null ? FileImage(image!) : null,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 4,
                          bottom: 4,
                          child: GestureDetector(
                            onTap: () async {
                              final picked = await pickImage();
                              if (picked != null) {
                                final cropped = await cropImage(picked);
                                if (cropped != null) {
                                  setState(() {
                                    image = File(cropped.path);
                                  });
                                }
                              }
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey.shade300,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: Image.asset(
                                    'assets/icons/edit.png',
                                    scale: 2.5,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'You\'re login with',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: credentialController,
                          hintText: 'john@gmail.com',
                          enabled: false,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Display Name',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: displayNameController,
                          keyboardType: TextInputType.name,
                          hintText: 'John Doe',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'Username',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: usernameController,
                          keyboardType: TextInputType.name,
                          hintText: '@johndoe',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: state is UserLoading
                      ? const LoadingButton()
                      : CustomButton(
                          title: 'Update',
                          disabled: areFieldsEmpty,
                          onTap: () {
                            if (!areFieldsEmpty) {
                              if (usernameController.text != oldUsername) {
                                context.read<UserBloc>().add(CheckUsernameEvent(usernameController.text));
                              } else {
                                handleImageUpload(context);
                              }
                            }
                          },
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void handleImageUpload(BuildContext context) {
    if (image != null) {
      context.read<UserBloc>().add(
            UploadToStorageEvent(
              uid: widget.user.uid.toString(),
              file: image!,
            ),
          );
    } else {
      context.read<UserBloc>().add(
            UpdateUserDataEvent(
              widget.user.copyWith(
                displayName: displayNameController.text,
                username: usernameController.text,
              ),
            ),
          );
    }
  }
}
