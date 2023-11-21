import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:intl/intl.dart';

//todo add persitent storage for session cookie

class AuthHelper {
  static String defaultHost = RouteHandler.defaultHost;
  static Map<String, dynamic> userInfoCache = Map();
  static Map<String, dynamic> languageNames = Map();

  static Future<Response> login(String email, String password) async {
    final data = {'email': email, 'password': password};
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';

    //this is the dio library making a post request
    try {
      final response = await RouteHandler.dio.post(
        url,
        data: jsonEncode(data),
        options: Options(contentType: Headers.jsonContentType),
      );
      await cacheUserInfo();
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
      final response = await RouteHandler.dio.post(
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
    var sessionCookie = await readCookie('session_cookie');
    if (sessionCookie == null) return false;
    await cacheUserInfo();
    return true;
  }

  static readCookie(String key) async {
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';
    Uri uri = Uri.parse(url);
    await RouteHandler.init();
    List<Cookie> cookies = await RouteHandler.cookieJar.loadForRequest(uri);
    for (var cookie in cookies) {
      if (cookie.name == key) {
        var decoded = Uri.decodeFull(cookie.value);
        //replace + with spaces
        decoded = decoded.replaceAll("+", " ");
        return json.decode(decoded);
      }
    }
  }

  static cacheUserInfo() async {
    var sessionCookie = await readCookie('session_cookie');
    String userID = sessionCookie['user_id'];
    String endPoint = '/getUserByID';
    var url = '$defaultHost$endPoint';
    var params = {
      'userID': userID,
    };

    try {
      final response = await RouteHandler.dio.get(url,
          queryParameters: params,
          options: Options(contentType: Headers.jsonContentType));
      var userInfo = response.data;
      userInfoCache['_id'] = userInfo['_id'];
      userInfoCache['email'] = userInfo['email'];
      userInfoCache['username'] = userInfo['username'];
      userInfoCache['language'] = userInfo['language'];
      userInfoCache['nationality'] = userInfo['nationality'];
      userInfoCache['profilePicture.url'] = userInfo['profilePicture.url'];
      userInfoCache['profilePicture.fileId'] =
          userInfo['profilePicture.fileId'];
      userInfoCache['admin'] = userInfo['admin'];
      try {
        endPoint = '/getLanguageDictionary';
        url = '$defaultHost$endPoint';
        final response2 = await RouteHandler.dio.get(url);
        languageNames = json.decode(response2.data);
      } on DioException catch (e) {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {'message': e},
          statusCode: 500,
        );
      }
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }
}
