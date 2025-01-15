import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_put.dart';
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
    "All Africa",
    "Western Africa",
    "Eastern Africa",
    "Northern Africa",
    "Southern Africa",
    "Algeria",
    "Angola",
    "Benin",
    "Botswana",
    "Burkina Faso",
    "Burundi",
    "Cabo Verde",
    "Cameroon",
    "Central African Republic",
    "Chad",
    "Comoros",
    "Congo",
    "Congo (DRC)",
    "Djibouti",
    "Egypt",
    "Equatorial Guinea",
    "Eritrea",
    "Eswatini",
    "Ethiopia",
    "Gabon",
    "Gambia",
    "Ghana",
    "Guinea",
    "Guinea-Bissau",
    "Ivory Coast",
    "Kenya",
    "Lesotho",
    "Liberia",
    "Libya",
    "Madagascar",
    "Malawi",
    "Mali",
    "Mauritania",
    "Mauritius",
    "Morocco",
    "Mozambique",
    "Namibia",
    "Niger",
    "Nigeria",
    "Rwanda",
    "Sao Tome and Principe",
    "Senegal",
    "Seychelles",
    "Sierra Leone",
    "Somalia",
    "South Africa",
    "South Sudan",
    "Sudan",
    "Tanzania",
    "Togo",
    "Tunisia",
    "Uganda",
    "Zambia",
    "Zimbabwe"
  ];
  final Map<String, bool> selectedInterest = {};
  String? userID;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userID = prefs.getString('id');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: ListView(
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
                    mainAxisExtent: 40,
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
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: isSelected ? accentColor : greyColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Text(
                            textAlign: TextAlign.center,
                            interest[0].toUpperCase() + interest.substring(1),
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
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
                    onTap: () {
                      final selectedInterests = selectedInterest.entries
                          .where((entry) => entry.value)
                          .map((entry) => entry.key)
                          .toList();

                      interestUpdate(
                        context: context,
                        userID: "$userID",
                        interests: selectedInterests,
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ActiveSession(),
                        ),
                        (Route<dynamic> route) =>
                            false, // This removes all routes from the stack.
                      );
                    },
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
