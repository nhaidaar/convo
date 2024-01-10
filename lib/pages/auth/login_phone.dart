import 'package:convo/blocs/auth/auth_bloc.dart';
import 'package:convo/config/method.dart';
import 'package:convo/config/theme.dart';
import 'package:convo/pages/auth/login_email.dart';
import 'package:convo/pages/auth/login_otp.dart';
import 'package:convo/pages/auth/widgets/login_circle.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String countryCode = '+62';

  void onCountryChange(CountryCode newCountryCode) {
    setState(() {
      countryCode = newCountryCode.toString();
    });
  }

  TextEditingController phoneController = TextEditingController();
  bool isPhoneEmpty = true;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(updateFieldState);
  }

  @override
  void dispose() {
    phoneController.removeListener(updateFieldState);
    phoneController.dispose();
    super.dispose();
  }

  void updateFieldState() {
    setState(() {
      isPhoneEmpty = phoneController.text.isEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthOtpSent) {
            Navigator.push(
              context,
              PageTransition(
                child: LoginOtp(
                  phoneNumber: countryCode + phoneController.text,
                  verificationId: state.verificationId,
                ),
                type: PageTransitionType.rightToLeft,
              ),
            );
          }
          if (state is AuthSuccess) {
            Navigator.push(
              context,
              PageTransition(
                child: const Home(),
                type: PageTransitionType.rightToLeft,
              ),
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
              body: ListView(
                padding: const EdgeInsets.all(30),
                children: [
                  Image.asset(
                    'assets/images/logo_full.png',
                    scale: 5,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Container(
                        width: 90,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: CountryCodePicker(
                          onChanged: onCountryChange,
                          padding: EdgeInsets.zero,
                          initialSelection: countryCode,
                        ),
                      ),
                      Expanded(
                        child: CustomFormField(
                          controller: phoneController,
                          hintText: '812 3456 7890',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomButton(
                    title: 'Continue with Phone',
                    disabled: isPhoneEmpty,
                    action: () {
                      final finalNumber = countryCode + phoneController.text;
                      if (!isPhoneEmpty) {
                        context
                            .read<AuthBloc>()
                            .add(PhoneSendOtpEvent(finalNumber));
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Text(
                          'or with',
                          style: mediumTS.copyWith(
                              fontSize: 16, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            height: 1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      LoginCircle(
                        iconUrl: 'assets/icons/login_email.png',
                        action: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: const LoginEmailPage(),
                              type: PageTransitionType.rightToLeft,
                            ),
                          );
                        },
                      ),
                      LoginCircle(
                        iconUrl: 'assets/icons/login_google.png',
                        action: () {
                          showSnackbar(context, 'Coming soon!');
                        },
                      ),
                    ],
                  )
                ],
              ),
              bottomNavigationBar: BottomAppBar(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Text(
                    'Version 1.0.0',
                    style: mediumTS,
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
