import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/auth/login_email.dart';
import 'package:convo/pages/auth/set_profile.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class RegisterEmailPage extends StatefulWidget {
  const RegisterEmailPage({super.key});

  @override
  State<RegisterEmailPage> createState() => _RegisterEmailPageState();
}

class _RegisterEmailPageState extends State<RegisterEmailPage> {
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
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                child: SetProfilePage(
                  model: UserModel(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                    credentials: emailController.text,
                  ),
                ),
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
                  'Register with Email',
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
                    height: 40,
                  ),
                  CustomButton(
                    title: 'Register',
                    disabled: areFieldsEmpty,
                    action: () {
                      if (!areFieldsEmpty) {
                        context.read<AuthBloc>().add(
                              EmailSignUpEvent(
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
                      text: 'Already have an account? ',
                      style: mediumTS,
                      children: [
                        TextSpan(
                            text: 'Sign In',
                            style: semiboldTS.copyWith(color: blue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    child: const LoginEmailPage(),
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
