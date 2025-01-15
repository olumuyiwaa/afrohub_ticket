import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/active_session.dart';
import 'api_helper.dart';

Future<void> profileUpdate({
  required BuildContext context,
  required File? image,
  required String userID,
  required String fullName,
  required String phone,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request =
      http.MultipartRequest('PUT', Uri.parse('$baseUrl/users/profile/$userID'))
        ..headers.addAll(headers)
        ..fields['full_name'] = fullName
        ..fields['phone_number'] = phone;
  if (image != null) {
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
  }

  try {
    // Send the request
    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Save data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64Image = base64Encode(bytes);
        await prefs.setString('image', base64Image);
      }
      await prefs.setString('full_name', fullName);
      await prefs.setString('phone_number', phone);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Profile Updated successfully!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    const ActiveSession(pageIndex: 4)));
      }
    } else {
      // Handle error response
      String errorMessage = 'Profile Update failed';
      try {
        final responseData = await http.Response.fromStream(response);
        errorMessage =
            json.decode(responseData.body)['message'] ?? errorMessage;
      } catch (_) {
        errorMessage = 'An unexpected error occurred';
      }
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
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to update profile: $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
    rethrow;
  }
}

Future<void> interestUpdate({
  required BuildContext context,
  required String userID,
  required List<String> interests,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request = http.Request('PUT', Uri.parse('$baseUrl/users/profile/$userID'))
    ..headers.addAll(headers)
    ..body = json.encode({
      'interests': interests,
    });

  try {
    // Send the request
    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Save data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('interests', interests);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            'Profile Updated successfully!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ));
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) =>
                    const ActiveSession(pageIndex: 4)));
      }
    } else {
      // Handle error response
      String errorMessage = 'Profile Update failed';
      try {
        final responseData = await http.Response.fromStream(response);
        errorMessage =
            json.decode(responseData.body)['message'] ?? errorMessage;
      } catch (_) {
        errorMessage = 'An unexpected error occurred';
      }
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
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Failed to update interests: $e',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
    rethrow;
  }
}

Future<void> updateEvent({
  required BuildContext context,
  required String eventID,
  required String title,
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
      http.MultipartRequest('PUT', Uri.parse('$baseUrl/events/$eventID'))
        ..headers.addAll(headers)
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
          'Event updated successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage =
        json.decode(responseData.body)['message'] ?? 'Event update failed';

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

Future<void> updateCountry({
  required BuildContext context,
  required File? coverImage,
  required File? leaderImage,
  required String countryTitle,
  required String countryID,
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
  var request = http.MultipartRequest(
      'PUT', Uri.parse('$baseUrl/country/countries/$countryID'))
    ..headers.addAll(headers)
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
          'Country updated successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    }
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage =
        json.decode(responseData.body)['message'] ?? 'Country update failed';

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
