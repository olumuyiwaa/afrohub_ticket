import 'dart:async';

import 'package:flutter/material.dart';

import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import 'creat_new_password.dart';

class ForgotPasswordOtp extends StatefulWidget {
  final String email; // Pass the email to this page

  const ForgotPasswordOtp({super.key, required this.email});

  @override
  // ignore: library_private_types_in_public_api
  _ForgotPasswordOtpState createState() => _ForgotPasswordOtpState();
}

class _ForgotPasswordOtpState extends State<ForgotPasswordOtp> {
  final List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());
  final List<TextEditingController> _otpControllers =
      List.generate(4, (_) => TextEditingController());

  // Timer for resend countdown
  Timer? _timer;
  int _start = 30;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    // Dispose timer along with controllers and focus nodes
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void _submitOtp() {
    String otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length == 4) {
      // Call verifyEmail function here
      // resetPasswordOTP(
      //   context: context,
      //   email: widget.email,
      //   verificationCode: otp,
      // ).then((_) {
      if (mounted) {
        // Navigate to the next page if successful and widget is still mounted
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => CreateNewPassword(
              email: widget.email,
            ),
          ),
        );
      }
      // }).catchError((error) {
      //   if (mounted) {
      //     // Handle the error and show a Snackbar
      //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //       content: Text(
      //         error.toString(),
      //         textAlign: TextAlign.center,
      //       ),
      //       backgroundColor: Colors.red,
      //     ));
      //   }
      // });
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "Please enter the 4-digit OTP sent to your email",
            textAlign: TextAlign.center,
          ),
        ));
      }
    }
  }

  Widget _buildOtpBox(int index) {
    return SizedBox(
      width: 64,
      child: TextField(
        style: TextStyle(fontSize: 24, color: accentColor),
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        maxLength: 1,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            hintText: '●',
            hintStyle: const TextStyle(color: Colors.grey),
            fillColor: const Color(0xFFFAFAFA),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: accentColor), // Change this to your desired color
            ),
            // Focused state (when the TextField is focused)
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: accentColor), // Change this to your desired color
            ),
            counterText: '',
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(width: 2, color: accentColor))),
        onChanged: (value) {
          if (value.isNotEmpty) {
            if (index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            } else {
              FocusScope.of(context).unfocus();
            }
          }
        },
        onSubmitted: (_) {
          if (index == 3) {
            _submitOtp();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 24,
            ),
            Text(
              'OTP Verification',
              style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  wordSpacing: -2),
            ),
            const Text(
              'Enter the verification code we just sent to your email address.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(4, _buildOtpBox),
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Button to resend OTP, disabled while timer is active

                TextButton(
                  onPressed: _start == 0
                      ? () {
                          // Implement resend OTP logic here
                          _startTimer(); // Restart the timer
                          setState(() {
                            _start = 30;
                          });
                        }
                      : null,
                  child: Text(
                    "Resend code in",
                    style: TextStyle(color: accentColor),
                  ),
                ),
                Text('00:${_start.toString().padLeft(2, '0')}'),
              ],
            ),
            const SizedBox(height: 24),
            InkWell(
              onTap: _submitOtp,
              child: const ButtonBig(buttonText: "Verify"),
            ),
          ],
        ),
      ),
    );
  }
}
