import 'package:flutter/material.dart';

import '/screens/active_session.dart';
import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import '../../../utilities/input/input_field.dart';

class CreateNewPassword extends StatefulWidget {
  final String email; // Pass the email to this page

  const CreateNewPassword({super.key, required this.email});

  @override
  State<CreateNewPassword> createState() => _CreateNewPasswordState();
}

class _CreateNewPasswordState extends State<CreateNewPassword> {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validator for the primary password field
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    } else if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // Validator for the confirm password field
  String? _validateConfirmPassword(String? value) {
    if (value != password.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 24),
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create new password!',
                  style: TextStyle(
                      color: accentColor,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      wordSpacing: -2),
                ),
                const Text(
                  'Your new password must be unique from those previously used',
                  style: TextStyle(
                      fontSize: 16,
                      wordSpacing: -2,
                      color: Color.fromARGB(224, 38, 50, 56)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Inputfield(
                    isreadOnly: false,
                    inputHintText: "Input Your New Password",
                    inputTitle: "New Password",
                    textObscure: false,
                    textController: password,
                    validator:
                        _validatePassword, // Apply primary password validation here
                  ),
                  Inputfield(
                    isreadOnly: false,
                    inputHintText: "Confirm Your New Password",
                    inputTitle: "Confirm New Password",
                    textObscure: false,
                    textController: confirmPassword,
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  // Proceed to reset password
                  // createNewPassword(
                  //     context: context,
                  //     email: widget.email,
                  //     newPassword: password.text);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              const ActiveSession()));
                }
              },
              child: const ButtonBig(
                buttonText: 'Reset Password',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
