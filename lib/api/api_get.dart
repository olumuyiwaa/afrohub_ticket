import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/events.dart';
import 'api_helper.dart';

Future<Map<String, dynamic>> getUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'id': prefs.getString('id'),
    'seller_id': prefs.getString('token'),
    'name': prefs.getString('full_name'),
    'phone_number': prefs.getString('email'),
    'email': prefs.getString('phone_number'),
  };
}

Future<List<Event>> getFeaturedEvents() async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/events/featured'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Event.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load events: ${response.statusCode}');
  }
}

Future<Event> getEventDetails(String eventID) async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/events/$eventID'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return Event.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Event Details: ${response.statusCode}');
  }
}
