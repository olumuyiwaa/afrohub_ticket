// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:flutter_stripe/flutter_stripe.dart';

import 'screens/active_session.dart';
import 'screens/auth/onboarding/splash_screens.dart';

Future<bool> isUserLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.containsKey('token');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLoggedIn = await isUserLoggedIn();

  // // Initialize Stripe SDK

  // Stripe.publishableKey =
  //     "your_stripe_publishable_key"; // Replace with your Stripe key

  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(AfroHub(
    isLoggedIn: isLoggedIn,
  ));
}

class AfroHub extends StatelessWidget {
  final bool isLoggedIn;

  const AfroHub({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 243, 243, 243),
        appBarTheme: const AppBarTheme(
            centerTitle: true,
            iconTheme: IconThemeData(),
            backgroundColor: Color.fromARGB(255, 243, 243, 243)),
        applyElevationOverlayColor: false,
        fontFamily: 'Poppins', //global font family
      ),
      home: isLoggedIn ? const ActiveSession() : const SplashScreens(),
    );
  }
}
