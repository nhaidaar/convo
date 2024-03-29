import 'package:convo/src/features/auth/bloc/auth_bloc.dart';
import 'package:convo/src/utils/method.dart';
import 'package:convo/src/constants/theme.dart';
import 'package:convo/src/common/widgets/custom_button.dart';
import 'package:convo/src/common/widgets/custom_textfield.dart';
import 'package:convo/src/common/widgets/default_leading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  bool isEmailEmpty = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    emailController.removeListener(updateFieldState);
    emailController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      isEmailEmpty = emailController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSent) {
            showSnackbar(context, 'We\'ve sent confirmation email to ${emailController.text}');
          }
          if (state is AuthError) {
            showSnackbar(context, state.e);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Forgot Password',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: const DefaultLeading(),
              ),
              body: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Text(
                    'Email',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'john@gmail.com',
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  state is AuthLoading
                      ? const LoadingButton()
                      : CustomButton(
                          title: 'Send Confirmation Email',
                          disabled: isEmailEmpty,
                          onTap: () {
                            if (!isEmailEmpty) {
                              context.read<AuthBloc>().add(ForgotPasswordEvent(emailController.text));
                            }
                          },
                        ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
