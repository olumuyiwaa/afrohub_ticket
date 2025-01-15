import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:afrohub/utilities/buttons/button_big.dart';
import 'package:afrohub/utilities/const.dart';
import 'package:afrohub/utilities/input/input_drop_down.dart';
import 'package:afrohub/utilities/input/input_field_large.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

import '../../../utilities/input/input_field.dart';

class EditEvent extends StatefulWidget {
  final String title;
  final String location;
  final String description;
  final String date;
  final String time;
  final String price;
  final String address;
  final String image;
  const EditEvent(
      {super.key,
      required this.title,
      required this.location,
      required this.description,
      required this.date,
      required this.time,
      required this.price,
      required this.address,
      required this.image});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  File? _coverImage;
  TimeOfDay? selectedTime;
  String latitude = "";
  String longitude = "";

  // Controllers for input fields
  final eventTitle = TextEditingController();
  final eventLocation = TextEditingController();
  final eventDescription = TextEditingController();
  final eventDate = TextEditingController();
  final eventTime = TextEditingController();
  final eventPrice = TextEditingController();
  final eventAddress = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    eventTitle.text = widget.title;
    eventLocation.text = widget.location;
    eventDescription.text = widget.description;
    eventDate.text = widget.date;
    eventTime.text = widget.time;
    eventPrice.text = widget.price;
    eventAddress.text = widget.address;
  }

  final List<String> categories = [
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
  String? selectedCategory;

  // Pick Cover Image
  Future<void> _pickCoverImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _coverImage = File(pickedFile.path);
      });
    }
  }

  // Pick Time
  Future<void> selectTime(BuildContext context) async {
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
        });
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        eventTime.text =
            "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> getLatLongFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude.toString();
          longitude = locations.first.longitude.toString();
        });
      }
    } catch (e) {
      //to use catch here
    }
  }

  // Submit Form Handler
  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      getLatLongFromAddress(eventAddress.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Event"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
          children: [
            // Cover Image
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
                    ? Image.file(
                        _coverImage!,
                        fit: BoxFit.cover,
                      )
                    : (widget.image.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, size: 40, color: greyColor),
                              const SizedBox(height: 8),
                              const Text("Add Cover Image"),
                            ],
                          )
                        : _buildImage(widget.image)),
              ),
            ),
            const SizedBox(height: 20),

            // Event Title
            Inputfield(
              isreadOnly: false,
              inputHintText: "Enter Event Title",
              inputTitle: "Event Title",
              textObscure: false,
              textController: eventTitle,
              validator: (eventTitle) =>
                  eventTitle == null || eventTitle.isEmpty
                      ? 'Event Title is required'
                      : null,
            ),
            Inputfield(
              isreadOnly: false,
              inputHintText: "1600 Amphitheatre Parkway, Mountain View, CA",
              inputTitle: "Event Address",
              textObscure: false,
              textController: eventAddress,
              validator: (value) =>
                  value == null || value.isEmpty ? 'Address is required' : null,
            ),
            Inputfield(
              isreadOnly: false,
              inputHintText: "e.g New-York",
              inputTitle: "City",
              textObscure: false,
              textController: eventLocation,
              validator: (value) => value == null || value.isEmpty
                  ? 'Location is required'
                  : null,
            ),
            // Event Category
            InputDropDown(
              options: categories,
              onOptionSelected: (value) => setState(() {
                selectedCategory = value;
              }),
              inputTitle: 'Event Theme',
            ),

            // Event Description
            InputFieldLarge(
              inputHintText: "Enter Event Description",
              inputTitle: "Description",
              textController: eventDescription,
            ),

            // Event Price
            Row(
              children: [
                Expanded(
                    child: Inputfield(
                  isreadOnly: false,
                  inputHintText: "Enter Event Price",
                  inputTitle: "Price (\$)",
                  textObscure: false,
                  textController: eventPrice,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Event Price is required'
                      : null,
                )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Inputfield(
                  isreadOnly: false,
                  inputHintText: "Total Number of Tickets",
                  inputTitle: "Total Unit",
                  textObscure: false,
                  textController: eventPrice,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Event Price is required'
                      : null,
                ))
              ],
            ),

            // Event Date and Time
            Row(
              children: [
                Expanded(
                    child: Inputfield(
                  isreadOnly: true,
                  inputHintText:
                      "${DateTime.now().year.toString()}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}",
                  inputTitle: "Date of the Event",
                  textObscure: false,
                  textController: eventDate,
                  icon: IconButton(
                    onPressed: () async {
                      final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
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
                          });
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
                )),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Inputfield(
                  isreadOnly: true,
                  inputHintText:
                      "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString().padLeft(2, '0')}",
                  inputTitle: "Time (24 Hour Clock)",
                  textObscure: false,
                  textController: eventTime,
                  icon: IconButton(
                    onPressed: () => selectTime(context),
                    icon: Icon(Icons.access_time, color: greyColor),
                  ),
                  validator: (eventTime) =>
                      eventTime == null || eventTime.isEmpty
                          ? 'Event Time is required'
                          : null,
                ))
              ],
            ),

            // Submit Button
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

  Widget _buildImage(String image) {
    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => Center(
          child: Lottie.asset(
            'assets/lottie/image.json',
            fit: BoxFit.cover,
          ),
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.image_not_supported_outlined,
          size: 160,
        ),
        fit: BoxFit.cover,
      );
    } else {
      if (image.isNotEmpty) {
        final Uint8List decodedBytes = base64Decode(image);
        return Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
          height: 254,
          width: 254,
        );
      } else {
        return const Icon(
          Icons.image_not_supported_outlined,
          size: 160,
        );
      }
    }
  }
}
