import 'package:afrohub/utilities/input/input_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/auth.dart';

class AccountDeactivationPage extends StatefulWidget {
  const AccountDeactivationPage({super.key});

  @override
  State<AccountDeactivationPage> createState() =>
      _AccountDeactivationPageState();
}

class _AccountDeactivationPageState extends State<AccountDeactivationPage> {
  String? userEmail;
  String? userPassword;
  String? userId;

  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userEmail = prefs.getString('email');
      userPassword = prefs.getString('password');
      userId = prefs.getString('id');
    });
  }

  Future<void> deactivateAccount() async {
    final String password = _passwordController.text.trim();

    if (password.isEmpty) {
      _showSnackBar("Password cannot be empty.", Colors.red);
      return;
    }

    if (userPassword != password) {
      _showSnackBar("Password is incorrect, please try again.", Colors.red);
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Call your API
      await deleteAccount(context: context, userID: userId);
    } catch (error) {
      _showSnackBar("Failed to deactivate account. Error: $error", Colors.red);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
      ),
      backgroundColor: color,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Deactivate Account")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            const Text(
              "Warning",
              style: TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Deactivating your account will result in the loss of all your saved data and preferences. "
              "This action cannot be undone.",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Inputfield(
              inputHintText: "Enter your password",
              inputTitle: "Password",
              textObscure: false,
              textController: _passwordController,
              isreadOnly: false,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : deactivateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Deactivate Account",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
