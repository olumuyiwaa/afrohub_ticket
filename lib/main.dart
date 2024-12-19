// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_stripe/flutter_stripe.dart';

import 'screens/auth/onboarding/splash_screens.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // // Initialize Stripe SDK

  // Stripe.publishableKey =
  //     "your_stripe_publishable_key"; // Replace with your Stripe key

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  runApp(const AfroHub());
}

class AfroHub extends StatelessWidget {
  const AfroHub({super.key});

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
      home: const SplashScreens(),
    );
  }
}
