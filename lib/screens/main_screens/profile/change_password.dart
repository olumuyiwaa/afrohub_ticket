import 'package:flutter/material.dart';

import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/input/input_field.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController currentPassword = TextEditingController();
  final TextEditingController newPassword = TextEditingController();
  final TextEditingController confirmNewPassword = TextEditingController();

  String? _validateConfirmPassword(String? value) {
    if (value != newPassword.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _updatePassword() async {
    if (newPassword.text != confirmNewPassword.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      // await updatePassword(
      //   context: context,
      //   oldPassword: currentPassword.text,
      //   newPassword: newPassword.text,
      //   confirmPassword: confirmNewPassword.text,
      // );
      // ignore: empty_catches
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'A Change of Password?',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    "Update your password below. To ensure it's you making the change, please enter your current password first.",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 64),
                child: Column(
                  children: [
                    Inputfield(
                      isreadOnly: false,
                      inputHintText: 'Input your current password',
                      inputTitle: 'Current Password',
                      textObscure: false,
                      textController: currentPassword,
                      validator: (value) => value!.isEmpty
                          ? 'Current password is required'
                          : null,
                    ),
                    Inputfield(
                      isreadOnly: false,
                      inputHintText: 'Input your new password',
                      inputTitle: 'New Password',
                      textObscure: false,
                      textController: newPassword,
                      validator: (value) =>
                          value!.isEmpty ? 'New password is required' : null,
                    ),
                    Inputfield(
                      isreadOnly: false,
                      inputHintText: 'Confirm your new password',
                      inputTitle: 'Confirm New Password',
                      textObscure: false,
                      textController: confirmNewPassword,
                      validator: _validateConfirmPassword,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _updatePassword();
                    }
                  },
                  child: const ButtonBig(buttonText: 'Update Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
