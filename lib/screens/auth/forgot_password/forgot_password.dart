import 'package:afrohub/screens/auth/forgot_password/forgot_password_otp.dart';
import 'package:flutter/material.dart';

import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import '../../../utilities/input/input_field.dart';
import '../sign_in.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Forgot Password?',
                style: TextStyle(
                    color: accentColor,
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    wordSpacing: -2),
              ),
              const Text(
                "We've got you covered. Enter the email address associated with your account.",
                style: TextStyle(
                    fontSize: 16,
                    wordSpacing: -2,
                    color: Color.fromARGB(224, 38, 50, 56)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Inputfield(
                  inputHintText: 'email@server.com',
                  inputTitle: 'Email Address',
                  textObscure: false,
                  textController: email,
                  isreadOnly: false,
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          ForgotPasswordOtp(email: email.text)));
              // resetPassword(context: context, email: email.text);
            },
            child: const ButtonBig(
              buttonText: 'Send Code',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Remember your password?",
                style: TextStyle(
                    fontSize: 14,
                    wordSpacing: -2,
                    color: Color.fromARGB(224, 38, 50, 56)),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const SignIn()));
                },
                child: Text(
                  'Login Now',
                  style: TextStyle(
                      fontSize: 18,
                      wordSpacing: -2,
                      fontWeight: FontWeight.w500,
                      color: accentColor),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
