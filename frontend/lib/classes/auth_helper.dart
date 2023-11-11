import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:cookie/cookie.dart' as cookie;

class AuthHelper {
  static String defaultHost = "http://10.0.2.2:8000";
  static String sessionCookie = "";
  static String cookies = "";

  static Future<Response> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    String endPoint = '/login';
    final url = Uri.parse('$defaultHost$endPoint');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': AuthHelper.cookies
        },
        body: jsonEncode(data));
    if (response.statusCode == 200) {
      List<String> cookies = response.headers['set-cookie']!.split(';');

      for (var cookie in cookies) {
        if (cookie.contains('session_cookie')) {
          cookie = cookie.replaceAll('session_cookie', '"session_cookie"');
          cookie = cookie.replaceAll("=", ":");
          //replace single quotes with double quotes
          cookie = cookie.replaceAll("'", '"');
          cookie = "{${cookie!}}";
          AuthHelper.sessionCookie = cookie;
          print(AuthHelper.sessionCookie);
          await AuthHelper.writeCookie(
              'sessionCookie', AuthHelper.sessionCookie);
        }
      }
      AuthHelper.cookies = response.headers['set-cookie']!;
      AuthHelper.writeCookie('cookies', AuthHelper.cookies);
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
    //replace session_cookie with "session_cookie"
    print(cookie);
    //turn to dictionary
    print("here");
    if (cookie != null) {
      String? jsonCookie = json.decoder.convert(cookie);
      print(jsonCookie);
      //also need to check for expiration date
      return true;
    } else {
      return false;
    }
  }
}
