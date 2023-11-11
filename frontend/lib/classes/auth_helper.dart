import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

final cookieJar = CookieJar();
final dio = Dio();

//todo add persitent storage for session cookie

class AuthHelper {
  static String defaultHost = "http://10.0.2.2:8000";

  static Future<Response> login(String email, String password) async {
    dio.interceptors.add(CookieManager(cookieJar));
    dio.options.connectTimeout = const Duration(seconds: 5);

    final data = {'email': email, 'password': password};
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';

    //this is the dio library making a post request
    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(contentType: Headers.jsonContentType),
      );
      return response;

      //on anything but a 200 response this code will run
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {'message': 'Unable to connect to server'},
          statusCode: 500,
          statusMessage: 'Unable to connect to server',
        );
      }
    }
  }

  static Future<Response> signUp(String email, String password) async {
    final data = {'email': email, 'password': password};
    String endPoint = '/signup';
    final url = '$defaultHost$endPoint';
    try {
      final response = await dio.post(
        url,
        data: jsonEncode(data),
        options: Options(contentType: Headers.jsonContentType),
      );
      return response;
    } on DioException catch (e) {
      if (e.response != null) {
        return e.response!;
      } else {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {'message': 'Unable to connect to server'},
          statusCode: 500,
          statusMessage: 'Unable to connect to server',
        );
      }
    }
  }

  static Future<bool> isLoggedIn() async {
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';
    Uri uri = Uri.parse(url);
    List<Cookie> cookies = await cookieJar.loadForRequest(uri);

    for (var cookie in cookies) {
      if (cookie.name == 'session_cookie') {
        var decoded = Uri.decodeFull(cookie.value);
        decoded = decoded.replaceAll("+", " ");
        var cookieObject = json.decode(decoded);
        String expiration = cookieObject['expires'];
        DateTime now = DateTime.now();
        DateTime expirationDate =
            DateFormat('EEE, dd MMM yyyy HH:mm:ss').parse(expiration);
        if (now.isBefore(expirationDate)) {
          return true;
        } else {
          return false;
        }
      }
    }
    return false;
  }

  static readCookie(String key) async {
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';
    Uri uri = Uri.parse(url);
    List<Cookie> cookies = await cookieJar.loadForRequest(uri);
    for (var cookie in cookies) {
      if (cookie.name == key) {
        var decoded = Uri.decodeFull(cookie.value);
        //replace + with spaces
        decoded = decoded.replaceAll("+", " ");
        return json.decode(decoded);
      }
    }
  }
}
