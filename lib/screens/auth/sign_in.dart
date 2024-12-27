// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../api/auth.dart';
import '../../utilities/buttons/button_big.dart';
import '../../utilities/const.dart';
import '../../utilities/input/input_field.dart';
import 'forgot_password/forgot_password.dart';
import 'onboarding/sign_up.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;

  final email = TextEditingController();
  final password = TextEditingController();
  bool _isPasswordVisible = false;

  Future<void> _signIn() async {
    signInAuth(context, email.text, password.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 64, 24, 24),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: TextStyle(
                    color: accentColor,
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    wordSpacing: -2),
              ),
              Text(
                'Glad to see you again!',
                style:
                    TextStyle(fontSize: 20, wordSpacing: -2, color: greyColor),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Inputfield(
                  inputHintText: 'email@server.com',
                  inputTitle: 'Email Address',
                  textObscure: false,
                  textController: email,
                  isreadOnly: false,
                ),
                Inputfield(
                  isreadOnly: false,
                  inputHintText: 'Input Your Password',
                  inputTitle: 'Password',
                  textObscure:
                      !_isPasswordVisible, // Toggle password visibility
                  textController: password,
                  icon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: greyColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                ForgotPassword()));
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(
                        wordSpacing: -2,
                        fontWeight: FontWeight.w500,
                        color: accentColor),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          InkWell(
            onTap: () {
              _signIn();
            },
            child: const ButtonBig(
              buttonText: 'Sign In',
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Don't have an account?",
                style: TextStyle(
                    fontSize: 14,
                    wordSpacing: -2,
                    color: Color.fromARGB(224, 38, 50, 56)),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => const SignUp()));
                },
                child: Text(
                  'Register Now',
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
