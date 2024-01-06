import 'package:convo/config/theme.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class LoginOtp extends StatefulWidget {
  const LoginOtp({super.key});

  @override
  State<LoginOtp> createState() => _LoginOtpState();
}

class _LoginOtpState extends State<LoginOtp> {
  TextEditingController otp = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'We\'ve send you an OTP',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Text(
                '+62 812 3456 7890',
                style: semiboldTS.copyWith(fontSize: 18, wordSpacing: 2),
                textAlign: TextAlign.center,
              ),
            ),
            Form(
              child: Pinput(
                androidSmsAutofillMethod: AndroidSmsAutofillMethod.none,
                controller: otp,
                length: 4,
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
                    ),
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
            child: CustomButton(
              title: 'Continue',
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Home(),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
