import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
