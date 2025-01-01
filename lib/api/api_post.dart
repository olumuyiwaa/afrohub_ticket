import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'api_helper.dart';

Future<void> createEvent({
  required BuildContext context,
  required String title,
  required String userID,
  required String location,
  required String price,
  required String category,
  required String date,
  required String time,
  required String address,
  required String description,
  required String latitude,
  required String longitude,
  required String unit,
  required File? coverImage,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseUrl/events/createvent'))
        ..headers.addAll(headers)
        ..fields['creator_id'] = userID
        ..fields['title'] = title
        ..fields['location'] = location
        ..fields['price'] = price
        ..fields['category'] = category
        ..fields['date'] = date
        ..fields['time'] = time
        ..fields['address'] = address
        ..fields['description'] = description
        ..fields['latitude'] = latitude
        ..fields['longitude'] = longitude
        ..fields['unit'] = unit;
  if (coverImage != null) {
    request.files
        .add(await http.MultipartFile.fromPath('image', coverImage.path));
  }
  // Send the request
  final response = await request.send();

  // Handle the response
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Event created successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage =
        json.decode(responseData.body)['message'] ?? 'Event creation failed';

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
    throw Exception(errorMessage);
  }
}

Future<void> createCountry({
  required BuildContext context,
  required File? coverImage,
  required File? leaderImage,
  required String userID,
  required String countryTitle,
  required String countryDescription,
  required String countryCapital,
  required String countryCurrency,
  required String countryPopulation,
  required String countryDemonym,
  required String countryLanguage,
  required String countryTimeZone,
  required String countryPresident,
  required String countryCuisinesLink,
  required String email,
  required String phoneNumber,
  required String leaderName,
  required String latitude,
  required String longitude,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request =
      http.MultipartRequest('POST', Uri.parse('$baseUrl/country/countries'))
        ..headers.addAll(headers)
        ..fields['created_by_id'] = userID
        ..fields['title'] = countryTitle
        ..fields['description'] = countryDescription
        ..fields['capital'] = countryCapital
        ..fields['currency'] = countryCurrency
        ..fields['population'] = countryPopulation
        ..fields['demonym'] = countryDemonym
        ..fields['language'] = countryLanguage
        ..fields['time_zone'] = countryTimeZone
        ..fields['president'] = countryPresident
        ..fields['link'] = countryCuisinesLink
        ..fields['association_leader_email'] = email
        ..fields['association_leader_phone'] = phoneNumber
        ..fields['association_leader_name'] = leaderName
        ..fields['latitude'] = latitude
        ..fields['longitude'] = longitude;
  if (coverImage != null && leaderImage != null) {
    request.files
        .add(await http.MultipartFile.fromPath('image', coverImage.path));
  }
  if (leaderImage != null) {
    request.files.add(await http.MultipartFile.fromPath(
        'association_leader_photo', leaderImage.path));
  }
  // Send the request
  final response = await request.send();

  // Handle the response
  if (response.statusCode == 200 || response.statusCode == 201) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Country created successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage =
        json.decode(responseData.body)['message'] ?? 'Country creation failed';

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          errorMessage,
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
    throw Exception(errorMessage);
  }
}
