import 'package:afrohub/utilities/input/input_field.dart';
import 'package:flutter/material.dart';

import '../../auth/sign_in.dart';

class AccountDeactivationPage extends StatefulWidget {
  const AccountDeactivationPage({Key? key}) : super(key: key);

  @override
  _AccountDeactivationPageState createState() =>
      _AccountDeactivationPageState();
}

class _AccountDeactivationPageState extends State<AccountDeactivationPage> {
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void deactivateAccount() async {
    final String password = _passwordController.text.trim();

    if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Password cannot be empty.",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Replace with your API call logic
      await Future.delayed(const Duration(seconds: 2)); // Simulating API call

      setState(() {
        _isLoading = false;
      });

      // Show success message and navigate
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "Account successfully deactivated.",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.green,
      ));

      // Navigate to the sign-in page or home screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const SignIn()), // Replace with your SignInPage
        (route) => false,
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to deactivate account. Error: $error",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Deactivate Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Warning",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Deactivating your account will result in the loss of all your saved data and preferences. "
              "This action cannot be undone.",
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            Inputfield(
                inputHintText: "Enter your password",
                inputTitle: "Enter your password",
                textObscure: false,
                textController: _passwordController,
                isreadOnly: false),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : deactivateAccount,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Deactivate Account",
                        style: TextStyle(fontSize: 16, color: Colors.red),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
