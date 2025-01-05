import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '/utilities/buttons/button_big.dart';
import '/utilities/const.dart';
import '/utilities/input/input_drop_down.dart';
import '/utilities/input/input_field_large.dart';
import '../../../api/api_post.dart';
import '../../../utilities/input/input_field.dart';

class CreateCountry extends StatefulWidget {
  const CreateCountry({super.key});

  @override
  State<CreateCountry> createState() => _CreateCountryState();
}

class _CreateCountryState extends State<CreateCountry> {
  File? _coverImage;
  File? _leaderImage;
  String latitude = "";
  String longitude = "";

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

  final _formKey = GlobalKey<FormState>();

// Initialize the controllers
  final TextEditingController countryDescription = TextEditingController();
  final TextEditingController countryCapital = TextEditingController();
  final TextEditingController countryCurrency = TextEditingController();
  final TextEditingController countryPopulation = TextEditingController();
  final TextEditingController countryDemonym = TextEditingController();
  final TextEditingController countryLanguage = TextEditingController();
  final TextEditingController countryTimeZone = TextEditingController();
  final TextEditingController countryPresident = TextEditingController();
  final TextEditingController countryCuisinesLink = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();
  final TextEditingController leaderName = TextEditingController();

// Dispose method
  @override
  void dispose() {
    countryDescription.dispose();
    countryCapital.dispose();
    countryCurrency.dispose();
    countryPopulation.dispose();
    countryDemonym.dispose();
    countryLanguage.dispose();
    countryTimeZone.dispose();
    countryPresident.dispose();
    countryCuisinesLink.dispose();
    email.dispose();
    phoneNumber.dispose();
    leaderName.dispose();
    super.dispose();
  }

  final List<String> africanCountries = [
    "Select Country",
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

  String? selectedAfricanCountry;

  bool isLoading = false;

  // Utility methods
  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickLeaderImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _leaderImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _getLatLongFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude.toString();
          longitude = locations.first.longitude.toString();
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch location. Please check the address.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });

      await _getLatLongFromAddress("$selectedAfricanCountry");

      setState(() {
        isLoading = false;
      });

      await createCountry(
        context: context,
        userID: "$userID",
        countryTitle: "$selectedAfricanCountry",
        countryCapital: countryCapital.text,
        countryDescription: countryDescription.text,
        latitude: latitude,
        longitude: longitude,
        coverImage: _coverImage,
        leaderImage: _leaderImage,
        countryCurrency: countryCurrency.text,
        countryPopulation: countryPopulation.text,
        countryDemonym: countryDemonym.text,
        countryLanguage: countryLanguage.text,
        countryTimeZone: countryTimeZone.text,
        countryPresident: countryPresident.text,
        countryCuisinesLink: countryCuisinesLink.text,
        email: email.text,
        phoneNumber: phoneNumber.text,
        leaderName: leaderName.text,
      );
    }
  }

  Widget _buildInputField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    bool isReadOnly = false,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return Inputfield(
      isreadOnly: isReadOnly,
      inputHintText: hintText,
      inputTitle: title,
      textObscure: false,
      textController: controller,
      validator: validator,
      icon: suffixIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Upload Country Details",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          children: [
            GestureDetector(
              onTap: _pickCoverImage,
              child: Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  border: Border.all(color: greyColor),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: _coverImage != null
                    ? Image.file(_coverImage!, fit: BoxFit.cover)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add, size: 40, color: greyColor),
                          const SizedBox(height: 8),
                          const Text("Add Cover Image"),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),
            InputDropDown(
              options: africanCountries,
              onOptionSelected: (value) {
                setState(() {
                  selectedAfricanCountry = value;
                });
              },
              inputTitle: 'Country Name',
              validator: (value) {
                if (selectedAfricanCountry == null ||
                    selectedAfricanCountry == "" ||
                    selectedAfricanCountry == "Select Country") {
                  return 'Please select a valid country';
                }
                return null;
              },
            ),
            Inputfield(
              inputHintText: "John Doe",
              inputTitle: "President",
              textObscure: false,
              textController: countryPresident,
              isreadOnly: false,
              validator: (countryPresident) =>
                  countryPresident == null || countryPresident.isEmpty
                      ? 'Country President Name is Required'
                      : null,
            ),
            InputFieldLarge(
              inputHintText: "Enter Event Description",
              inputTitle: "Description",
              textController: countryDescription,
              validator: (value) => value == null || value.isEmpty
                  ? 'Country Description is Required'
                  : null,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    title: "Capital",
                    hintText: "Capital",
                    controller: countryCapital,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country Capital is required'
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInputField(
                    title: "Currency",
                    hintText: "Naira N",
                    controller: countryCurrency,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country Currency is required'
                        : null,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    title: "Population",
                    hintText: "Population",
                    controller: countryPopulation,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country Population is required'
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInputField(
                    title: "Demonym",
                    hintText: "e.g Nigerian",
                    controller: countryDemonym,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country Demonym is required'
                        : null,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    title: "Language",
                    hintText: "Language",
                    controller: countryLanguage,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country Population is required'
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildInputField(
                    title: "Time Zone",
                    hintText: "TimeZone",
                    controller: countryTimeZone,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Country Time Zone is required'
                        : null,
                  ),
                )
              ],
            ),
            _buildInputField(
              title: "Cuisines Tutorial Link",
              hintText: "https://",
              controller: countryCuisinesLink,
              validator: (value) => value == null || value.isEmpty
                  ? 'Country Cuisines Tutorial Link is required'
                  : null,
            ),
            const Divider(),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Details About Country's Association Leader",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickLeaderImage,
                    child: Container(
                      width: double.infinity,
                      height: 190,
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[200],
                      ),
                      child: _leaderImage != null
                          ? Image.file(_leaderImage!, fit: BoxFit.cover)
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,
                                    size: 40, color: greyColor),
                                const SizedBox(height: 8),
                                const Text("Add Leader Image"),
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      _buildInputField(
                        title: "Email",
                        hintText: "johndoe@email.com",
                        controller: email,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Email is required'
                            : null,
                      ),
                      _buildInputField(
                        title: "Phone Number",
                        hintText: "+1234567890",
                        controller: phoneNumber,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Phone Number is required'
                            : null,
                      )
                    ],
                  ),
                )
              ],
            ),
            _buildInputField(
              title: "Name Of Association Leader",
              hintText: "John Doe",
              controller: leaderName,
              validator: (value) => value == null || value.isEmpty
                  ? 'Name Of Association Leader is required'
                  : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: InkWell(
                onTap: _submitForm,
                child: const ButtonBig(buttonText: "Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
