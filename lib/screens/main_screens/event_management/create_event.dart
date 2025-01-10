import 'dart:io';

import 'package:afrohub/utilities/buttons/button_big.dart';
import 'package:afrohub/utilities/const.dart';
import 'package:afrohub/utilities/input/input_drop_down.dart';
import 'package:afrohub/utilities/input/input_field_large.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/api_post.dart';
import '../../../utilities/input/input_field.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  File? _coverImage;
  TimeOfDay? selectedTime;
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

  // Controllers for input fields
  final TextEditingController eventTitle = TextEditingController();
  final TextEditingController eventLocation = TextEditingController();
  final TextEditingController eventDescription = TextEditingController();
  final TextEditingController eventDate = TextEditingController();
  final TextEditingController eventTime = TextEditingController();
  final TextEditingController eventPrice = TextEditingController();
  final TextEditingController eventAddress = TextEditingController();
  final TextEditingController eventUnit = TextEditingController();

  final List<String> africanCountries = [
    "Select Country",
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

  String selectedAfricanCountry = "All Africa";

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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: accentColor,
              onPrimary: Colors.white,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        eventTime.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
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

      await _getLatLongFromAddress(eventAddress.text);

      setState(() {
        isLoading = false;
      });

      await createEvent(
        context: context,
        userID: "$userID",
        title: eventTitle.text,
        location: eventLocation.text,
        price: eventPrice.text,
        category: selectedAfricanCountry,
        date: eventDate.text,
        time: eventTime.text,
        address: eventAddress.text,
        description: eventDescription.text,
        latitude: latitude,
        longitude: longitude,
        unit: eventUnit.text,
        coverImage: _coverImage,
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
          "Create Event",
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
                clipBehavior: Clip.hardEdge,
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
            _buildInputField(
              title: "Event Title",
              hintText: "Enter Event Title",
              controller: eventTitle,
              validator: (value) => value == null || value.isEmpty
                  ? 'Event Title is required'
                  : null,
            ),
            _buildInputField(
              title: "Event Address",
              hintText: "1600 Amphitheatre Parkway, Mountain View, CA",
              controller: eventAddress,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Address is required' : null,
            ),
            _buildInputField(
              title: "Location",
              hintText: "Event Location",
              controller: eventLocation,
              validator: (value) => value == null || value.isEmpty
                  ? 'Location is required'
                  : null,
            ),
            InputDropDown(
              options: africanCountries,
              onOptionSelected: (value) => setState(() {
                selectedAfricanCountry = value;
              }),
              inputTitle: 'Event Theme',
              validator: (value) => selectedAfricanCountry == "Select Country"
                  ? 'Please select a valid country'
                  : null,
            ),
            InputFieldLarge(
              inputHintText: "Enter Event Description",
              inputTitle: "Description",
              textController: eventDescription,
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    title: "Price (\$)",
                    hintText: "Enter Event Price",
                    controller: eventPrice,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Event Price is required'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    title: "Total Unit",
                    hintText: "Total Number of Tickets",
                    controller: eventUnit,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Event Unit is required'
                        : null,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    title: "Date of the Event",
                    hintText: "YYYY-MM-DD",
                    controller: eventDate,
                    isReadOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (pickedDate != null) {
                          eventDate.text =
                              "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
                        }
                      },
                      icon: Icon(Icons.calendar_today, color: greyColor),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Event Date is required'
                        : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildInputField(
                    title: "Time (24 Hour Clock)",
                    hintText: "HH:MM",
                    controller: eventTime,
                    isReadOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () => _selectTime(context),
                      icon: Icon(Icons.access_time, color: greyColor),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Event Time is required'
                        : null,
                  ),
                ),
              ],
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
