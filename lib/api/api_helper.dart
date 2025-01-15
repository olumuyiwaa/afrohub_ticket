import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'https://afrohub.onrender.com/api';

Future<Map<String, String>> getHeaders() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');
  return {
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };
}
