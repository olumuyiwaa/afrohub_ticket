import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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

Future<void> bookmarkEvent({
  required BuildContext context,
  required String userID,
  required String eventID,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request = http.MultipartRequest(
      'POST', Uri.parse('$baseUrl/bookmark/$userID/bookmarks/$eventID'))
    ..headers.addAll(headers);
  final response = await request.send();

  // Handle the response
  if (response.statusCode == 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Event added to bookmarks successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    }
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage = json.decode(responseData.body)['message'] ??
        'Failed to add to bookmarks';

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

Future<void> initiatePaypalPayment({
  required BuildContext context,
  required String ticketId,
  required int ticketCount,
}) async {
  try {
    // API URL
    final Uri uri =
        Uri.parse('https://ticketbackend-0iem.onrender.com/api/paypal/pay');

    // Request headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Request body
    final Map<String, dynamic> body = {
      'ticketId': ticketId,
      'ticketCount': ticketCount,
    };

    // Make the POST request
    final response = await http.post(
      uri,
      headers: headers,
      body: json.encode(body),
    );

    if (response.statusCode == HttpStatus.movedPermanently ||
        response.statusCode == HttpStatus.found) {
      // Get the Location header (new URL)
      var redirectUrl = response.headers['location'];
      if (redirectUrl != null) {
        Navigator.pop(context);
        // Launch the redirect URL in an external browser or app
        if (await canLaunch(redirectUrl)) {
          await launch(redirectUrl);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch the URL'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      final errorMessage = response.body;
      debugPrint(
          'Error Response: $errorMessage'); // Log the error for debugging
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Error: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
      throw Exception('Payment failed: ${response.statusCode}');
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    debugPrint('Payment Error: $e');
    rethrow;
  }
}

// Stripe payment method
Future<void> handleStripePayment({
  required BuildContext context,
  required String ticketId,
  required int ticketCount,
}) async {
  try {
    // API URL for creating PaymentIntent
    final Uri stripeUri = Uri.parse(
        'https://ticketbackend-0iem.onrender.com/api/stripe/create-payment-intent');

    // Request headers
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // Request body
    final Map<String, dynamic> body = {
      'ticketId': ticketId,
      'ticketCount': ticketCount,
    };

    // Make the POST request to create a PaymentIntent
    final response = await http.post(
      stripeUri,
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Parse PaymentIntent response
      final paymentIntentData = jsonDecode(response.body);

      // Initialize Stripe payment sheet with the necessary data
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Afro Hub', // Replace with your business name
        ),
      );

      // Display payment sheet
      await Stripe.instance.presentPaymentSheet();

      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Successful")),
        );
      }
    } else {
      final errorMessage = response.body;
      debugPrint('Error Response: $errorMessage');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment Error: $errorMessage'),
            backgroundColor: Colors.red,
          ),
        );
      }
      throw Exception('Payment failed with status: ${response.statusCode}');
    }
  } catch (e) {
    // Handle and log errors
    debugPrint('Payment Error: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
    print('Error: ${e.toString()}');
    rethrow; // Rethrow error if needed for further handling
  }
}
