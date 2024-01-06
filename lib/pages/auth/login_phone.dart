import 'package:convo/config/theme.dart';
import 'package:convo/pages/auth/login_email.dart';
import 'package:convo/pages/auth/login_otp.dart';
import 'package:convo/pages/auth/widgets/login_circle.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                  child: const CountryCodePicker(
                    padding: EdgeInsets.zero,
                    initialSelection: '+62',
                  ),
                ),
                const Expanded(
                  child: CustomFormField(
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
              action: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginOtp(),
                  ),
                );
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
                    style: mediumTS.copyWith(fontSize: 16, color: Colors.grey),
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
                      MaterialPageRoute(
                        builder: (context) => const LoginEmailPage(),
                      ),
                    );
                  },
                ),
                LoginCircle(
                  iconUrl: 'assets/icons/login_google.png',
                  action: () {},
                ),
              ],
            )
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: Text.rich(
              TextSpan(
                text: 'nhaidaar - Build with ',
                style: semiboldTS.copyWith(fontSize: 15),
                children: [
                  TextSpan(
                    text: '♥️',
                    style: semiboldTS.copyWith(
                      fontSize: 15,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
