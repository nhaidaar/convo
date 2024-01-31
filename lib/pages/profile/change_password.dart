import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/repositories/auth_repository.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/default_leading.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _user = FirebaseAuth.instance.currentUser;

  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final currentPasswordFocusNode = FocusNode();
  final newPasswordFocusNode = FocusNode();

  bool _newPasswordVisible = false;
  bool _currentPasswordVisible = false;

  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    currentPasswordFocusNode.dispose();
    newPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocProvider(
        create: (context) => AuthBloc(auth: AuthRepository()),
        child: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pop(context);
              showSnackbar(context, 'Password changed!');
            }
            if (state is AuthError) {
              showSnackbar(
                context,
                state.e == 'channel-error' ? 'Please insert your current password!' : state.e,
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Change Password',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: const DefaultLeading(),
              ),
              body: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Password',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: currentPasswordController,
                          focusNode: currentPasswordFocusNode,
                          hintText: 'We need this to verify your password',
                          isPassword: true,
                          obscureText: !_currentPasswordVisible,
                          onTap: () {
                            setState(() {
                              _currentPasswordVisible = !_currentPasswordVisible;
                            });
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          'New Password',
                          style: semiboldTS,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomFormField(
                          controller: newPasswordController,
                          focusNode: newPasswordFocusNode,
                          hintText: 'Don\'t share your password!',
                          isPassword: true,
                          obscureText: !_newPasswordVisible,
                          onTap: () {
                            setState(() {
                              _newPasswordVisible = !_newPasswordVisible;
                            });
                          },
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
                  child: state is AuthLoading
                      ? const LoadingButton()
                      : CustomButton(
                          title: 'Update',
                          onTap: () {
                            context.read<AuthBloc>().add(
                                  ChangePasswordEvent(
                                    email: _user!.email!,
                                    currentPassword: currentPasswordController.text,
                                    newPassword: newPasswordController.text,
                                  ),
                                );
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
