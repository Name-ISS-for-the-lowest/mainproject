import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';

class AuthHelper {
  static String defaultHost = "http://10.0.2.2:8000";
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
      AuthHelper.writeCookie('sessionCookie', AuthHelper.sessionCookie);
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

  static readCookie(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static writeCookie(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static deleteCookie(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  static Future<bool> isLoggedIn() async {
    String? cookie = await readCookie('sessionCookie');
    print(cookie);
    print("hello there");
    return false;
    if (cookie != null) {
      //also need to check for expiration date
      return true;
    } else {
      return false;
    }
  }
}
