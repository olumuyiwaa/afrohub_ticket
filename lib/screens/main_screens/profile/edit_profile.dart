import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import '../../../api/api_put.dart';
import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import '../../../utilities/input/input_field.dart';

class EditProfile extends StatefulWidget {
  final String name;
  final String phone;
  final String userID;
  const EditProfile(
      {super.key,
      required this.name,
      required this.phone,
      required this.userID});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
                InkWell(
                    child: const ButtonBig(
                      buttonText: 'Save',
                    ),
                    onTap: () {
                      profileUpdate(
                        context: context,
                        image: _profileImage,
                        userID: widget.userID,
                        fullName: fullName.text,
                        phone: phoneNumber.text,
                      );
                    })
              ],
            ),
          )
        ],
      ),
    );
  }
}
