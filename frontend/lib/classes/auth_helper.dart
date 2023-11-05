import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class AuthHelper {
  static String defaultHost = "http://10.0.2.2:5000";
  static String sessionCookie = "";

  static Future<Response> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    String endPoint = '/login';
    final url = Uri.parse('$defaultHost$endPoint');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': sessionCookie
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      AuthHelper.sessionCookie = response.headers['set-cookie']!;
    }
    return response;
  }

  static Future<Response> signUp(String email, String password) async {
    final data = {'email': email, 'password': password};
    String endPoint = '/signup';
    final url = Uri.parse('$defaultHost$endPoint');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': sessionCookie
        },
        body: jsonEncode(data));
    return response;
  }
}
