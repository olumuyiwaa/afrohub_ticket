import 'package:flutter/material.dart';

import '../const.dart';

class ButtonBig extends StatelessWidget {
  final String buttonText;
  final Widget icon;
  final bool isdark;
  final bool isGradient;

  const ButtonBig(
      {super.key,
      required this.buttonText,
      this.isdark = true,
      this.isGradient = false,
      this.icon = const SizedBox.shrink()});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: isGradient ? ColorConstants.appGradient : null,
        color: isGradient
            ? null
            : isdark
                ? const Color(0xFF263238)
                : Colors.white,
        border: Border.all(
          color: const Color.fromARGB(224, 38, 50, 56),
          width: 1,
        ),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: icon,
            ),
            Text(
              buttonText,
              style: TextStyle(
                color: isdark || isGradient
                    ? Colors.white
                    : const Color(0xFF263238),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
