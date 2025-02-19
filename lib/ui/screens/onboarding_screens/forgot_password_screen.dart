import 'package:flutter/material.dart';
import '../../widgets/black_button.dart';
import '../../widgets/error_message.dart';
import 'login_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _employeeId = '';
  String _phoneNumber = '';
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Forgot Your Password?\nNo worries, We got you covered!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 30),

              // Employee ID Field
              const Text(
                "Employee ID",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    _employeeId = value;
                    _errorMessage = null; // Hide error message when typing
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your emp_id",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              const Text(
                "Phone number",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextFormField(
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    _phoneNumber = value;
                    _errorMessage = null; // Hide error message when typing
                  });
                },
                decoration: InputDecoration(
                  hintText: "Enter your phone number",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Error Message
              if (_errorMessage != null)
                ErrorMessage(message: _errorMessage!),
              const SizedBox(height: 15),

              // Send Password Reset Link Button
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: BlackButton(
                    text: "Send Password Reset Link",
                    onPressed: () {
                      if (_employeeId.isEmpty || _phoneNumber.isEmpty) {
                        setState(() {
                          _errorMessage = "Please enter both Employee ID and Phone Number.";
                        });
                      } else {
                        // Add your reset password logic here
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Back to Login Text
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(color: Colors.black54, fontSize: 14),
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
