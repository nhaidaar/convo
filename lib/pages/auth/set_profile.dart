// ignore_for_file: use_build_context_synchronously

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

class SetProfilePage extends StatefulWidget {
  final UserModel model;
  const SetProfilePage({super.key, required this.model});

  @override
  State<SetProfilePage> createState() => _SetProfilePageState();
}

class _SetProfilePageState extends State<SetProfilePage> {
  final displayNameController = TextEditingController();
  final usernameController = TextEditingController();

  File? image;
  bool areFieldsEmpty = true;

  @override
  void initState() {
    super.initState();
    displayNameController.addListener(updateFieldState);
    usernameController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    displayNameController.removeListener(updateFieldState);
    usernameController.removeListener(updateFieldState);
    displayNameController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      areFieldsEmpty =
          displayNameController.text.isEmpty || usernameController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc(),
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserStoreFileSuccess) {
            final finalModel = widget.model.copyWith(
              displayName: displayNameController.text,
              username: usernameController.text,
              profilePicture: state.url,
            );
            context.read<UserBloc>().add(PostUserDataEvent(finalModel));
          }

          if (state is UserSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                child: const Home(),
                type: PageTransitionType.fade,
              ),
              (route) => false,
            );
          }

          if (state is UserError) {
            showSnackbar(context, state.e);
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: blue,
                  ),
                ),
              );
            }
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'One Step Again',
                  style: semiboldTS,
                ),
                centerTitle: true,
              ),
              body: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                children: [
                  GestureDetector(
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
                    child: Center(
                      child: CircleAvatar(
                        radius: 80,
                        backgroundColor: Colors.grey.shade300,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundColor: Colors.white,
                            foregroundImage:
                                image != null ? FileImage(image!) : null,
                            child: Image.asset(
                              'assets/icons/add_photo.png',
                              scale: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
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
                    'Username (without @)',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    controller: usernameController,
                    keyboardType: TextInputType.name,
                    hintText: 'johndoe',
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: CustomButton(
                    title: 'Continue',
                    disabled: areFieldsEmpty,
                    action: () {
                      if (!areFieldsEmpty) {
                        context.read<UserBloc>().add(
                              UploadToStorageEvent(
                                uid: widget.model.uid!,
                                file: image!,
                              ),
                            );
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
}
