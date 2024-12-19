import 'package:flutter/material.dart';

import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import '../../active_session.dart';

class OnboardInterest extends StatefulWidget {
  const OnboardInterest({super.key});

  @override
  State<OnboardInterest> createState() => _OnboardInterestState();
}

class _OnboardInterestState extends State<OnboardInterest> {
  final List<dynamic> categories = [
    "swimming",
    "game",
    "football",
    "comedy",
    "concert",
    "trophy",
    "tour",
    "festival",
    "study",
    "party",
    "olympic",
    "culture"
  ];
  final Map<String, bool> selectedInterest = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              'Please Select the events you are interested in',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ),
          const Spacer(),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    mainAxisExtent: 120,
                  ),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final interest = categories[index];
                    final isSelected = selectedInterest[interest] ?? false;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedInterest[interest] = !isSelected;
                        });
                      },
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : greyColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? accentColor : greyColor,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(height: 4),
                            Image.asset(
                              "assets/img/$interest.png",
                              width: 40,
                              height: 40,
                              fit: BoxFit.contain,
                            ),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: isSelected ? accentColor : Colors.white,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  interest[0].toUpperCase() +
                                      interest.substring(1),
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24),
                  child: InkWell(
                    child: const ButtonBig(
                      buttonText: 'Continue',
                    ),
                    onTap: () => Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            const ActiveSession(),
                      ),
                      (Route<dynamic> route) =>
                          false, // This removes all routes from the stack.
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
