// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../api/auth.dart';
import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import '../../../utilities/input/input_field.dart';
import '../sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();
  final phoneNumber = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  Future<void> _registerUser() async {
    if (!_formKey.currentState!.validate()) return;
    signUpAuth(context, email.text, password.text, confirmPassword.text,
        name.text, phoneNumber.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 24),
              Inputfield(
                isreadOnly: false,
                inputHintText: "John Doe",
                inputTitle: "Full Name",
                textObscure: false,
                textController: name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Full Name is required';
                  }
                  return null;
                },
              ),
              Inputfield(
                isreadOnly: false,
                inputHintText: "email@server.com",
                inputTitle: "Email Address",
                textObscure: false,
                textController: email,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              Inputfield(
                isreadOnly: false,
                inputHintText: "+1234567890",
                inputTitle: "Phone Number",
                textObscure: false,
                textController: phoneNumber,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              Inputfield(
                isreadOnly: false,
                inputHintText: "Input Your Password",
                inputTitle: "Password",
                textObscure: !_isPasswordVisible,
                textController: password,
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: greyColor,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Password must be at least 6 characters long';
                  }
                  return null;
                },
              ),
              Inputfield(
                isreadOnly: false,
                inputHintText: "Confirm Your Password",
                inputTitle: "Confirm Password",
                textObscure: !_isConfirmPasswordVisible,
                textController: confirmPassword,
                icon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                  icon: Icon(
                    _isConfirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: greyColor,
                  ),
                ),
                validator: (value) {
                  if (value != password.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: _registerUser,
                child: const ButtonBig(buttonText: "Create Account"),
              ),
              const SizedBox(height: 12),
              const Text(
                "By clicking 'Create Account', you agree to the app's User Agreements and Privacy Policy",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => const SignIn(),
                    ),
                  );
                },
                child: Text(
                  'Already have an account? Sign In',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
