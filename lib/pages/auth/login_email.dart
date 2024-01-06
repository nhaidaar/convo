import 'package:convo/config/theme.dart';
import 'package:convo/pages/home.dart';
import 'package:convo/widgets/custom_button.dart';
import 'package:convo/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class LoginEmailPage extends StatefulWidget {
  const LoginEmailPage({super.key});

  @override
  State<LoginEmailPage> createState() => _LoginEmailPageState();
}

class _LoginEmailPageState extends State<LoginEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Sign with Email',
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
              hintText: '******',
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Forgot Password?',
              style: semiboldTS.copyWith(color: blue),
              textAlign: TextAlign.end,
            ),
            const SizedBox(
              height: 40,
            ),
            CustomButton(
              title: 'Continue',
              action: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        'We can\'t find your account',
                        style: semiboldTS,
                        textAlign: TextAlign.center,
                      ),
                      content: Text.rich(
                        TextSpan(
                          text: 'Would you register as ',
                          style: regularTS,
                          children: [
                            TextSpan(
                              text: emailController.text,
                              style: mediumTS.copyWith(color: blue),
                            ),
                            TextSpan(
                              text: ' ?',
                              style: regularTS,
                            )
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      contentPadding: const EdgeInsets.all(30),
                      actions: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  invert: true,
                                  title: 'Cancel',
                                  action: () {},
                                ),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: CustomButton(
                                  title: 'Register',
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
                            ],
                          ),
                        )
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
        // bottomNavigationBar: BottomAppBar(
        //   elevation: 0,
        //   child: Padding(
        //     padding: const EdgeInsets.all(30),
        //     child: Text.rich(
        //       TextSpan(
        //         text: 'Don\'t have an account? ',
        //         style: mediumTS.copyWith(fontSize: 15),
        //         children: [
        //           TextSpan(
        //             text: 'Sign Up',
        //             style: semiboldTS.copyWith(fontSize: 15, color: blue),
        //           ),
        //         ],
        //       ),
        //       textAlign: TextAlign.center,
        //     ),
        //   ),
        // ),
      ),
    );
  }
}
