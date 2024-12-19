import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ColorConstants {
  static const appGradient = LinearGradient(
    colors: <Color>[
      Color(0xFF263238),
      Color(0xff0a9fbf),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

Color accentColor = "#0a9fbf".toColor();
Color bgColor = "#F5F9F9".toColor();
Color greyColor = "#869FAC".toColor();
Color borderColor = "#BCCCCD".toColor();
Color dividerColor = "#F1F5F5".toColor();
Color errorColor = "#DD3333".toColor();
Color lightGrey = "#FAFAFA".toColor();
Color lightColor = Colors.white;
Color lightAccent = '#F4FAFA'.toColor();
Color shadowColor = "#2690B7B9".toColor();
Color darkShadow = "#99000000".toColor();
Color lightShadow = "#00000000".toColor();

extension ColorExtension on String {
  toColor() {
    var hexColor = replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class Constant {
  static String assetImagePath = "assets/images/";
  static String assetSvgPath = "assets/svg/";
  static bool isDriverApp = false;
  static const String fontsFamily = "Gilroy";
  static const String fromLogin = "getFromLoginClick";
  static const String homePos = "getTabPos";
  static const int stepStatusNone = 0;
  static const int stepStatusActive = 1;
  static const int stepStatusDone = 2;
  static const int stepStatusWrong = 3;

  static double getPercentSize(double total, double percent) {
    return (percent * total) / 100;
  }

  static backToPrev(BuildContext context) {
    Get.back();
  }

  static getCurrency(BuildContext context) {
    return "ETH";
  }

  static sendToNext(BuildContext context, String route, {Object? arguments}) {
    if (arguments != null) {
      Get.toNamed(route, arguments: arguments);
    } else {
      Get.toNamed(route);
    }
  }

  static double getToolbarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + kToolbarHeight;
  }

  static double getToolbarTopHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static sendToScreen(Widget widget, BuildContext context) {
    Get.to(widget);
  }

  static backToFinish(BuildContext context) {
    Get.back();
  }

  static closeApp() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    });
  }
}
