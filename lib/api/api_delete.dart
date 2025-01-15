import 'dart:convert';

import 'package:afrohub/screens/main_screens/event_management/ticket_shop.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/active_session.dart';
import 'api_helper.dart';

Future<void> removeBookmarkEvent({
  required BuildContext context,
  required String userID,
  required String eventID,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request = http.Request(
      'DELETE', Uri.parse('$baseUrl/bookmark/$userID/bookmarks/$eventID'))
    ..headers.addAll(headers);
  final response = await request.send();

  // Handle the response
  if (response.statusCode == 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Event removed from bookmarks successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    }
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage = json.decode(responseData.body)['message'] ??
        'Failed to remove from bookmarks';

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

Future<void> removeEvent({
  required BuildContext context,
  required String eventID,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request =
      http.Request('DELETE', Uri.parse('$baseUrl/events/$eventID/delete'))
        ..headers.addAll(headers);
  final response = await request.send();

  // Handle the response
  if (response.statusCode == 200) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Event deleted successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const TicketShop(),
      ),
      (Route<dynamic> route) => false,
    );
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage =
        json.decode(responseData.body)['message'] ?? 'Failed to delete event';

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

Future<void> removeCountry({
  required BuildContext context,
  required String countryID,
}) async {
  var headers = await getHeaders();

  // Create multipart request
  var request =
      http.Request('DELETE', Uri.parse('$baseUrl/country/countries/$countryID'))
        ..headers.addAll(headers);
  final response = await request.send();

  // Handle the response
  if (response.statusCode == 200) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const ActiveSession(
                  pageIndex: 3,
                )));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          'Country deleted successfully!',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const ActiveSession(pageIndex: 3),
      ),
      (Route<dynamic> route) => false,
    );
  } else {
    final responseData = await http.Response.fromStream(response);
    final String errorMessage =
        json.decode(responseData.body)['message'] ?? 'Failed to delete country';

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
