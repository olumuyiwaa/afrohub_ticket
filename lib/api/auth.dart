// ignore_for_file: use_build_context_synchronously
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/active_session.dart';
import '../screens/auth/onboarding/onboard_interest.dart';
import '../screens/auth/sign_in.dart';
import 'api_helper.dart';

Future<void> signInAuth(
    BuildContext context, String email, String password) async {
  final Map<String, dynamic> body = {
    'email': email,
    'password': password,
  };

  try {
    // Make the POST request
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/users/login'),
      headers: headers,
      body: json.encode(body),
    );

    // Check the response status
    if (response.statusCode == 200) {
      // Decode the response to retrieve the token and user ID
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String id = responseData['id'];
      final String name = responseData['full_name'];
      final String email = responseData['email'];
      final String phone = responseData['phone_number'];
      final String token = responseData['token'];

      // Store the user details in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', id);
      await prefs.setString('token', token);
      await prefs.setString('full_name', name);
      await prefs.setString('email', email);
      await prefs.setString('phone_number', phone);
      await prefs.setString('password', password);
      // Show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Login successful",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to ActiveSession() on success
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ActiveSession()),
        (route) => false, // Removes all previous routes
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            json.decode(response.body)['message'],
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Handle any exceptions that occur during the HTTP request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> signUpAuth(BuildContext context, String email, String password,
    String confimPassword, String fullName, String phoneNumber) async {
  final Map<String, dynamic> body = {
    'email': email,
    'password': password,
    'confirm_password': confimPassword,
    'full_name': fullName,
    'phone_number': phoneNumber,
  };

  try {
    // Make the POST request
    final headers = await getHeaders();
    final response = await http.post(
      Uri.parse('$baseUrl/users/register'),
      headers: headers,
      body: json.encode(body),
    );

    // Check the response status
    if (response.statusCode == 201) {
      // Decode the response to retrieve the token and user ID
      final Map<String, dynamic> responseData = json.decode(response.body);
      final String id = responseData['id'];
      final String token = responseData['token'];
      final String name = responseData['full_name'];
      final String email = responseData['email'];
      final String phone = responseData['phone_number'];

      // Store the user details in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', id);
      await prefs.setString('token', token);
      await prefs.setString('full_name', name);
      await prefs.setString('email', email);
      await prefs.setString('phone_number', phone);
      await prefs.setString('password', password);

      // Show a success Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Account Created successfully!',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to ActiveSession() on success
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardInterest()),
        (route) => false, // Removes all previous routes
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            json.decode(response.body)['message'],
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    // Handle any exceptions that occur during the HTTP request
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          e.toString(),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> signOut({
  required BuildContext context,
}) async {
  try {
    final headers = await getHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/logout'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "You have successfully Signed Out",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SignIn(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Sign Out failed: ${response.reasonPhrase}",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Failed to Sign Out: $e",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}

Future<void> deleteAccount({
  required BuildContext context,
  required String? userID,
}) async {
  try {
    final headers = await getHeaders();
    final response = await http.delete(
      Uri.parse('$baseUrl/users/delete-account/?userId=$userID'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "User Account Successfully Deleted",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ));
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => const SignIn(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "User Account Delete failed: ${response.reasonPhrase}",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Failed To Delete User Account: $e",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ),
    );
  }
}
