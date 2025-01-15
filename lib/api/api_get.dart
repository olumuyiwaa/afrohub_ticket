import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/class_countries.dart';
import '../model/class_events.dart';
import '../model/class_tickets.dart';
import '../model/class_users.dart';
import 'api_helper.dart';

Future<Map<String, dynamic>> getUserInfo() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return {
    'id': prefs.getString('id'),
    'token': prefs.getString('token'),
    'full_name': prefs.getString('full_name'),
    'email': prefs.getString('email'),
    'phone_number': prefs.getString('phone_number'),
  };
}

Future<void> getUserProfile(String? userID) async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/bookmark/$userID/profile'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> responseData = json.decode(response.body);
    final String id = responseData['_id'];
    final String name = responseData['full_name'];
    final String phone = responseData['phone_number'];
    final String image = responseData.containsKey('image')
        ? responseData['image']
        : ''; // Handle cases where the image key might not exist
    final List<String> interests = List<String>.from(responseData['interests']);

    // Store the user details in SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('id', id);
    await prefs.setString('full_name', name);
    await prefs.setString('phone_number', phone);
    await prefs.setString('image', image);
    await prefs.setStringList('interests', interests);
  } else {
    throw Exception('Failed to Load User Details: ${response.statusCode}');
  }
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

Future<List<Event>> getBookmarkedEvents(String userID) async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/bookmark/$userID/bookmarks/'),
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

Future<List<Country>> getCountries() async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/country/countries'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Country.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load Countries: ${response.statusCode}');
  }
}

Future<Country> getCountryDetails(String countryID) async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/country/countries/$countryID'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    return Country.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Country Details: ${response.statusCode}');
  }
}

Future<List<Ticket>> fetchTickets() async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/paypal/payment-history'),
    headers: headers,
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonData = json.decode(response.body);
    return jsonData.map((json) => Ticket.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load tickets: ${response.reasonPhrase}');
  }
}

Future<List<User>> fetchUsers() async {
  final headers = await getHeaders();
  final response = await http.get(
    Uri.parse('$baseUrl/getusers/all-users'),
    headers: headers,
  );
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['data'];
    return data.map((userJson) => User.fromJson(userJson)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
