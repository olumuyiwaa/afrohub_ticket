// ignore_for_file: avoid_print

import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  Future<GoogleSignInAccount?> signInWithGoogle() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        // Handle signed-in user info
        print('Name: ${account.displayName}');
        print('Email: ${account.email}');
        print('Photo URL: ${account.photoUrl}');
      }
      return account;
    } catch (error) {
      print('Google Sign-In Error: $error');
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    print('User signed out');
  }
}
