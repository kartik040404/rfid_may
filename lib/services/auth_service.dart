import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//------------------ AuthService Class -------------//
class AuthService {
  //------------------ Base URL -------------//
  static const String baseUrl = 'http://192.168.1.9:3000';

  //------------------ Check if user is logged in -------------//
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token != null;
  }

  //------------------ Get current user data -------------//
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('userId');
    final employeeId = prefs.getString('employeeId');
    final employeeName = prefs.getString('employeeName');

    if (employeeId == null) return null;

    return {
      'id': userId,
      'employee_id': employeeId,
      'employee_name': employeeName,
    };
  }

  //------------------ Get auth token -------------//
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  //------------------ Login -------------//
  static Future<Map<String, dynamic>> login(
      String employeeId, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'employee_id': employeeId,
          'password': password,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', responseData['token']);
        await prefs.setString('userId', responseData['user']['id'].toString());
        await prefs.setString(
            'employeeId', responseData['user']['employee_id']);
        await prefs.setString(
            'employeeName', responseData['user']['employee_name']);

        return {
          'success': true,
          'user': responseData['user'],
        };
      } else {
        return {
          'success': false,
          'error': responseData['error'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'error': 'Connection error: $e',
      };
    }
  }

  //------------------ Logout -------------//
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('userId');
    await prefs.remove('employeeId');
    await prefs.remove('employeeName');
  }

  //------------------ Send authenticated request -------------//
  static Future<http.Response> authenticatedRequest(
    String endpoint, {
    String method = 'GET',
    Map<String, dynamic>? body,
  }) async {
    final token = await getToken();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    switch (method) {
      case 'GET':
        return http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
      case 'POST':
        return http.post(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers,
          body: json.encode(body),
        );
      case 'PUT':
        return http.put(
          Uri.parse('$baseUrl$endpoint'),
          headers: headers,
          body: json.encode(body),
        );
      case 'DELETE':
        return http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
      default:
        throw Exception('Unsupported HTTP method: $method');
    }
  }
}
