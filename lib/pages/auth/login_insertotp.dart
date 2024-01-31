// ignore_for_file: use_build_context_synchronously

import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/models/user_model.dart';
import 'package:convo/pages/auth/set_profile.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/services/user_services.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';
import 'package:pinput/pinput.dart';

import '../../widgets/default_leading.dart';

class LoginOtp extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  const LoginOtp({super.key, required this.verificationId, required this.phoneNumber});

  @override
  State<LoginOtp> createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp> {
  TextEditingController otpController = TextEditingController();
  bool isOtpEmpty = true;

  @override
  void initState() {
    super.initState();
    otpController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    otpController.removeListener(updateFieldState);
    otpController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      isOtpEmpty = otpController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            final user = FirebaseAuth.instance.currentUser;
            final userData = await UserService().getUserData(user!.uid);

            if (userData != null) {
              Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  child: const Home(),
                  type: PageTransitionType.fade,
                ),
                (route) => false,
              );
            } else {
              Navigator.of(context).pushAndRemoveUntil(
                PageTransition(
                  child: SetProfilePage(
                    model: UserModel(
                      uid: user.uid,
                      credentials: user.phoneNumber ?? user.email,
                    ),
                  ),
                  type: PageTransitionType.fade,
                ),
                (route) => false,
              );
            }
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
                  'We\'ve send you an OTP',
                  style: semiboldTS,
                ),
                centerTitle: true,
                leading: const DefaultLeading(),
              ),
              body: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text(
                      widget.phoneNumber,
                      style: semiboldTS.copyWith(fontSize: 18, wordSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Form(
                    child: Pinput(
                      androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                      controller: otpController,
                      length: 6,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Text.rich(
                      TextSpan(
                        text: 'Didn\'t receive the code? ',
                        style: mediumTS.copyWith(fontSize: 15),
                        children: [
                          TextSpan(
                              text: 'Resend',
                              style: semiboldTS.copyWith(fontSize: 15, color: blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  showSnackbar(context, 'Currently disabled!');
                                }),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: state is AuthLoading
                      ? const LoadingButton()
                      : CustomButton(
                          title: 'Continue',
                          disabled: isOtpEmpty,
                          onTap: () {
                            if (!isOtpEmpty) {
                              context.read<AuthBloc>().add(PhoneVerifyOtpEvent(otpController.text, widget.verificationId));
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
