import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://54.175.77.125:5000';

  static Future<bool> registerUser(String phoneNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'phone_number': phoneNumber, 'device_os': 'ios'}),
      );

      // Check for success code from Flask
      if (response.statusCode == 200 || response.statusCode == 201) {
        print('User successfully registered with backend.');
        return true;
      } else {
        print('Failed to register. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('API Connection Error: $e');
      return false;
    }
  }
}
