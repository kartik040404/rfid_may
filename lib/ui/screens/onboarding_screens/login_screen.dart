import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:testing_aar_file/ui/screens/onboarding_screens/onboarding_screen.dart';
import '../../widgets/black_button.dart';
import '../../widgets/error_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  String _employeeId = '',_employeeName='';
  String _password = '';
  String? _errorMessage;
  bool _isLoading = false;

  // Future<void> _login() async {
  //   if (_employeeId.isEmpty || _password.isEmpty) {
  //     setState(() {
  //       _errorMessage = "Please enter both Employee ID and Password.";
  //     });
  //     return;
  //   }
  //
  //   setState(() {
  //     _isLoading = true;
  //     _errorMessage = null;
  //   });
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://192.168.15.253:3000/login'), // server IP address
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'employee_id': _employeeId,
  //         'password': _password,
  //       }),
  //     );
  //
  //     setState(() {
  //       _isLoading = false;
  //     });
  //
  //     final responseData = json.decode(response.body);
  //
  //     if (response.statusCode == 200 && responseData['success'] == true) {
  //       // Login successful
  //       // Save user info to SharedPreferences
  //       _employeeName=responseData['user']['employee_name'];
  //       final prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('userId', responseData['user']['id'].toString());
  //       await prefs.setString('employeeId', responseData['user']['employee_id']);
  //       await prefs.setString('employeeName', responseData['user']['employee_name']);
  //       await prefs.setBool('isLoggedIn', true);
  //
  //       // Navigate to home screen
  //       Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(_employeeId,_employeeName),));
  //
  //     } else {
  //       // Login failed
  //       setState(() {
  //         _errorMessage = responseData['message'] ?? 'Authentication failed. Please try again.';
  //       });
  //     }
  //   } catch (e) {
  //     setState(() {
  //       _isLoading = false;
  //       _errorMessage = 'Connection error. Please check your internet connection.';
  //     });
  //     print('Login error: $e');
  //   }
  // }

  Future<void> _login() async {
    if (_employeeId.isEmpty || _password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter both Employee ID and Password.";
      });
      return;
    }

    // ✅ Hardcoded login check
    if (_employeeId == 'EMP001' && _password == 'password123') {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', '0');
      await prefs.setString('employeeId', _employeeId);
      await prefs.setString('employeeName', 'Demo User');
      await prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => OnboardingScreen(_employeeId, 'Demo User'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.15.253:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'employee_id': _employeeId,
          'password': _password,
        }),
      );

      setState(() {
        _isLoading = false;
      });

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 && responseData['success'] == true) {
        _employeeName = responseData['user']['employee_name'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', responseData['user']['id'].toString());
        await prefs.setString('employeeId', responseData['user']['employee_id']);
        await prefs.setString('employeeName', responseData['user']['employee_name']);
        await prefs.setBool('isLoggedIn', true);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OnboardingScreen(_employeeId, _employeeName),
          ),
        );
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'Authentication failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Connection error. Please check your internet connection.';
      });
      print('Login error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 26,
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

                // Password Field
                const Text(
                  "Password",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: _obscurePassword,
                  onChanged: (value) {
                    setState(() {
                      _password = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Error Message
                if (_errorMessage != null)
                  ErrorMessage(message: _errorMessage!),
                const SizedBox(height: 15),

                // Login Button
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : BlackButton(
                      text: "Log in",
                      onPressed: _login,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}