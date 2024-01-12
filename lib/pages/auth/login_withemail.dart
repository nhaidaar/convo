import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/auth/forgot_password.dart';
import 'package:convo/pages/auth/register_withemail.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordFocus = FocusNode();
  bool passwordHidden = true;
  bool areFieldsEmpty = true;

  @override
  void initState() {
    super.initState();
    emailController.addListener(updateFieldState);
    passwordController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    emailController.removeListener(updateFieldState);
    passwordController.removeListener(updateFieldState);
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      areFieldsEmpty =
          emailController.text.isEmpty || passwordController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              PageTransition(
                child: const Home(),
                type: PageTransitionType.fade,
              ),
              (route) => false,
            );
          }
          if (state is AuthError) {
            showSnackbar(context, state.e);
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthLoading) {
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
                  'Login with Email',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_new),
                ),
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
                    focusNode: emailFocus,
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'john@gmail.com',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Password',
                    style: semiboldTS,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomFormField(
                    controller: passwordController,
                    focusNode: passwordFocus,
                    hintText: '******',
                    isPassword: true,
                    obscureText: passwordHidden,
                    action: () {
                      setState(() {
                        passwordHidden = !passwordHidden;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransition(
                          child: const ForgotPasswordPage(),
                          type: PageTransitionType.rightToLeft,
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: semiboldTS.copyWith(color: blue),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomButton(
                    title: 'Continue',
                    disabled: areFieldsEmpty,
                    action: () {
                      if (!areFieldsEmpty) {
                        context.read<AuthBloc>().add(
                              EmailSignInEvent(
                                emailController.text,
                                passwordController.text,
                              ),
                            );
                      }
                    },
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: mediumTS,
                      children: [
                        TextSpan(
                            text: 'Sign Up',
                            style: semiboldTS.copyWith(color: blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.of(context).push(
                                  PageTransition(
                                    child: const RegisterEmailPage(),
                                    type: PageTransitionType.rightToLeft,
                                  ),
                                );
                              }),
                      ],
                    ),
                    textAlign: TextAlign.center,
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
