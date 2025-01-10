import 'package:flutter/material.dart';

import '../../../api/api_put.dart';
import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';

class UpdateInterests extends StatefulWidget {
  final String userID;
  const UpdateInterests({super.key, required this.userID});

  @override
  State<UpdateInterests> createState() => _UpdateInterestsState();
}

class _UpdateInterestsState extends State<UpdateInterests> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        children: [
          Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: Colors.white),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Interests',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Expanded(
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          mainAxisExtent: 40,
                        ),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final interest = categories[index];
                          final isSelected =
                              selectedInterest[interest] ?? false;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedInterest[interest] = !isSelected;
                              });
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: isSelected ? accentColor : greyColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  interest[0].toUpperCase() +
                                      interest.substring(1),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  InkWell(
                      child: const ButtonBig(
                        buttonText: 'Save',
                      ),
                      onTap: () {
                        final selectedInterests = selectedInterest.entries
                            .where((entry) => entry.value)
                            .map((entry) => entry.key)
                            .toList();

                        interestUpdate(
                          context: context,
                          userID: widget.userID,
                          interests: selectedInterests,
                        );
                      }),
                ],
              ))
        ],
      ),
    );
  }
}
