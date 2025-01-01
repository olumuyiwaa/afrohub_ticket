import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import '../../../utilities/input/input_field.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String phone;
  const EditProfile({super.key, required this.name, required this.phone});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

  final fullName = TextEditingController();
  final phoneNumber = TextEditingController();

  final Map<String, bool> selectedInterest = {};
  File? _profileImage;

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
      //    await updateImage(context: context, profileImage: _profileImage!);
    }
  }

  @override
  Widget build(BuildContext context) {
    fullName.text = widget.name;
    phoneNumber.text = widget.phone;
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
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(127),
                  child: Container(
                      height: 254,
                      width: 254,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(400),
                          color: greyColor,
                          border: Border.all(width: 2, color: greyColor)),
                      child: Container(
                        height: 254,
                        width: 254,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(127),
                          color: greyColor,
                        ),
                        child: Stack(
                          children: [
                            _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                    height: 254,
                                    width: 254,
                                  )
                                : CachedNetworkImage(
                                    imageUrl: "",
                                    placeholder: (context, url) => Center(
                                      child: CircularProgressIndicator(
                                        color: accentColor,
                                      ),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        SvgPicture.asset(
                                      'assets/svg/usericon.svg',
                                    ),
                                    fit: BoxFit.cover,
                                    height: 254,
                                    width: 254,
                                  ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right:
                                  0, // Ensures the container spans the full width
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: greyColor.withOpacity(0.8),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(
                                        127), // Match with the main border radius
                                  ),
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  onTap: () {
                    _pickImageFromGallery();
                  },
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'About',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Inputfield(
                      inputHintText: 'John Doe',
                      inputTitle: 'Full Name',
                      textObscure: false,
                      textController: fullName,
                      isreadOnly: false,
                    ),
                    Inputfield(
                      inputHintText: '+123456789',
                      inputTitle: 'Phone Number',
                      textObscure: false,
                      textController: phoneNumber,
                      isreadOnly: false,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Interests',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                        onTap: () {} // This removes all routes from the stack.
                        ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
