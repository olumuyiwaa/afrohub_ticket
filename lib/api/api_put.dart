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
      print(response.statusCode);
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
