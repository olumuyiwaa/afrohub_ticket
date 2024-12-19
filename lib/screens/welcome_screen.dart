import 'package:afrohub/utilities/buttons/button_big.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../provider/google_sign_in_provider.dart';
import 'auth/onboarding/sign_up.dart';
import 'auth/sign_in.dart';

class WelcomeScreen extends StatefulWidget {
  WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

  GoogleSignInAccount? _currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage('assets/welcome.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              bottom: 80,
            ),
            child: Column(
              children: [
                const Spacer(),
                Center(
                  child: _currentUser == null
                      ? InkWell(
                          onTap: () async {
                            final user =
                                await _googleSignInProvider.signInWithGoogle();
                            setState(() {
                              _currentUser = user;
                            });
                          },
                          child: ButtonBig(
                            icon: SvgPicture.asset("assets/svg/google.svg"),
                            buttonText: "Sign in with Google",
                            isdark: false,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(_currentUser!.photoUrl ?? ''),
                              radius: 40,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Name: ${_currentUser!.displayName}',
                              style: TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Email: ${_currentUser!.email}',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () async {
                                await _googleSignInProvider.signOut();
                                setState(() {
                                  _currentUser = null;
                                });
                              },
                              child: Text('Sign Out'),
                            ),
                          ],
                        ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const SignIn()));
                  },
                  child: const ButtonBig(buttonText: "Sign In With Email"),
                ),
                const SizedBox(
                  height: 24,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => const SignUp()));
                  },
                  child: const ButtonBig(
                    buttonText: "Sign Up With Email",
                    isdark: false,
                  ),
                ),
                const SizedBox(
                  height: 32,
                ),
              ],
            )),
      ),
    );
  }
}
