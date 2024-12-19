import 'package:afrohub/utilities/widget/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:afrohub/utilities/widget/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:flutter/material.dart';

import '../../../utilities/const.dart';
import '../../welcome_screen.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({super.key});

  @override
  State<SplashScreens> createState() => _SplashScreensState();
}

var _fontHeaderStyle =
    TextStyle(fontSize: 23.0, fontWeight: FontWeight.w700, color: accentColor);

var _fontDescriptionStyle = const TextStyle(
    fontSize: 16.0, color: Colors.grey, fontWeight: FontWeight.w400);

final pages = [
  PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Exploring Upcoming Events',
        style: _fontHeaderStyle,
        textAlign: TextAlign.center,
      ),
      body: SizedBox(
        height: 250.0,
        child: Text(
            'exploring upcoming events can be a fun and rewarding activity for anyone looking to occupy.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/img/onBoarding1.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Exploring Nearby Events',
        textAlign: TextAlign.center,
        style: _fontHeaderStyle,
      ),
      body: SizedBox(
        height: 250.0,
        child: Text(
            'Exploring nearby events is a great way to support local businesses and discover hidden gems in your community.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/img/onBoarding2.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
  PageViewModel(
      pageColor: Colors.white,
      iconColor: Colors.black,
      bubbleBackgroundColor: Colors.black,
      title: Text(
        'Search Around Maps',
        textAlign: TextAlign.center,
        style: _fontHeaderStyle,
      ),
      body: SizedBox(
        height: 250.0,
        child: Text(
            'Searching for events around maps is a great way to find activities and events that are close by and fit your interests.',
            textAlign: TextAlign.center,
            style: _fontDescriptionStyle),
      ),
      mainImage: Image.asset(
        'assets/img/onBoarding3.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      )),
];

class _SplashScreensState extends State<SplashScreens> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.white,
      child: IntroViewsFlutter(
        pages,
        pageButtonsColor: Colors.white,
        skipText: Text(
          "Skip",
          style: _fontDescriptionStyle.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        doneText: Text(
          "Done",
          style: _fontDescriptionStyle.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w500,
          ),
        ),
        onTapDoneButton: () async {
          Navigator.of(context).pushReplacement(
              PageRouteBuilder(pageBuilder: (_, __, ___) => WelcomeScreen()));
          // Get.toNamed(Routes.loginRoute);
        },
      ),
    );
  }
}
