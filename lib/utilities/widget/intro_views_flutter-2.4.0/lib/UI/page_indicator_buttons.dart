import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';

import '../Constants/constants.dart';
import '../Models/page_button_view_model.dart';

/// Skip button class

class SkipButton extends StatelessWidget {
  //callback for skip button
  final VoidCallback? onTap;
  //view model
  final PageButtonViewModel? pageButtonViewModel;
  final Widget? child;
  //Constructor
  const SkipButton({
    super.key,
    this.onTap,
    this.pageButtonViewModel,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    //Calculating opacity to create a fade in effect
    double? opacity = 1.0;
    final TextStyle style = DefaultTextStyle.of(context).style;
    if (pageButtonViewModel!.activePageIndex ==
            pageButtonViewModel!.totalPages! - 2 &&
        pageButtonViewModel!.slideDirection == SlideDirection.rightToLeft) {
      opacity = 1.0 - pageButtonViewModel!.slidePercent!;
    } else if (pageButtonViewModel!.activePageIndex ==
            pageButtonViewModel!.totalPages! - 1 &&
        pageButtonViewModel!.slideDirection == SlideDirection.leftToRight) {
      opacity = pageButtonViewModel!.slidePercent;
    }

    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1.2, color: borderColor),
              color: lightColor,
              borderRadius: BorderRadius.circular(8)),
          child: Opacity(
            opacity: opacity!,
            child: DefaultTextStyle.merge(
              style: style,
              child: child!,
            ), //Text
          ), //Opacity
        )); //FlatButton
  }
}

/// Done Button class

class DoneButton extends StatelessWidget {
  //Callback
  final VoidCallback? onTap;
  //View Model
  final PageButtonViewModel? pageButtonViewModel;
  final Widget? child;
  //Constructor
  const DoneButton({
    super.key,
    this.onTap,
    this.pageButtonViewModel,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    //Calculating opacity so as to create a fade in effect
    double opacity = 1.0;
    final TextStyle style = DefaultTextStyle.of(context).style;
    if (pageButtonViewModel!.activePageIndex ==
            pageButtonViewModel!.totalPages! - 1 &&
        pageButtonViewModel!.slideDirection == SlideDirection.leftToRight) {
      opacity = 1.0 - pageButtonViewModel!.slidePercent!;
    }

    return InkWell(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
              border: Border.all(width: 1.2, color: borderColor),
              color: lightColor,
              borderRadius: BorderRadius.circular(8)),
          child: Opacity(
            opacity: opacity,
            child: DefaultTextStyle.merge(
              style: style,
              child: child!, //Text
            ),
          ), //Opacity
        )); //FlatButton
  }
}

class PageIndicatorButtons extends StatelessWidget {
  //Some variables
  final int acitvePageIndex;
  final int totalPages;
  final VoidCallback? onPressedDoneButton; //Callback for Done Button
  final VoidCallback? onPressedSkipButton; //Callback for Skip Button
  final SlideDirection? slideDirection;
  final double? slidePercent;
  final bool showSkipButton;

  final Widget? doneText;
  final Widget? skipText;
  final TextStyle? textStyle;

  final bool? doneButtonPersist;

  //Constructor
  const PageIndicatorButtons({
    super.key,
    required this.acitvePageIndex,
    required this.totalPages,
    this.onPressedDoneButton,
    this.slideDirection,
    this.slidePercent,
    this.onPressedSkipButton,
    this.showSkipButton = true,
    this.skipText,
    this.doneText,
    this.textStyle,
    this.doneButtonPersist,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0.0,
      right: 0.0,
      bottom: 0.0,
      child: DefaultTextStyle(
        style: textStyle!,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: ((acitvePageIndex < totalPages - 1 ||
                          (acitvePageIndex == totalPages - 1 &&
                              slideDirection == SlideDirection.leftToRight)) &&
                      showSkipButton)
                  ? SkipButton(
                      onTap: onPressedSkipButton,
                      pageButtonViewModel: PageButtonViewModel(
                        //View Model
                        activePageIndex: acitvePageIndex,
                        totalPages: totalPages,
                        slidePercent: slidePercent,
                        slideDirection: slideDirection,
                      ),
                      child: skipText,
                    )
                  : Container(), //Row
            ), //Padding
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: (acitvePageIndex == totalPages - 1 ||
                      (acitvePageIndex == totalPages - 2 &&
                              slideDirection == SlideDirection.rightToLeft ||
                          doneButtonPersist!))
                  ? DoneButton(
                      onTap: onPressedDoneButton,
                      pageButtonViewModel: PageButtonViewModel(
                        //view Model
                        activePageIndex: acitvePageIndex,
                        totalPages: totalPages,
                        slidePercent: doneButtonPersist! ? 0.0 : slidePercent,
                        slideDirection: slideDirection,
                      ),
                      child: doneText,
                    )
                  : Container(), //Row
            ),
          ],
        ),
      ),
    );
  }
}
