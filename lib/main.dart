// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/active_session.dart';
import 'screens/auth/onboarding/onboarding_screens.dart';
import 'screens/auth/onboarding/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 243, 243, 243),
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Color.fromARGB(255, 243, 243, 243),
          centerTitle: true,
          iconTheme: IconThemeData(),
          backgroundColor: Color.fromARGB(255, 243, 243, 243),
        ),
        applyElevationOverlayColor: false,
        fontFamily: 'Poppins',
      ),
      home: const SplashScreen(),
    ));
  });
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
            surfaceTintColor: Color.fromARGB(255, 243, 243, 243),
            centerTitle: true,
            iconTheme: IconThemeData(),
            backgroundColor: Color.fromARGB(255, 243, 243, 243)),
        applyElevationOverlayColor: false,
        fontFamily: 'Poppins', //global font family
      ),
      home: isLoggedIn ? const ActiveSession() : const OnboardingScreens(),
    );
  }
}
