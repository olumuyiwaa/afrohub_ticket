import 'package:shared_preferences/shared_preferences.dart';

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
