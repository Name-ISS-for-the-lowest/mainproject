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
    String endPoint = '/login';
    var url = '$defaultHost$endPoint';
    Uri uri = Uri.parse(url);
    List<Cookie> cookies = await RouteHandler.cookieJar.loadForRequest(uri);

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
    String endPoint = '/login';
    String userID;
    var url = '$defaultHost$endPoint';
    Uri uri = Uri.parse(url);
    var data = {};
    List<Cookie> cookies = await RouteHandler.cookieJar.loadForRequest(uri);

    for (var cookie in cookies) {
      if (cookie.name == 'session_cookie') {
        var decoded = Uri.decodeFull(cookie.value);
        decoded = decoded.replaceAll("+", " ");
        var cookieObject = json.decode(decoded);
        userID = cookieObject['user_id'];
        print("the user id...");
        print(userID);
        data = {'userID': userID};
        break;
      }
    }
    endPoint = '/getUserByID';
    url = '$defaultHost$endPoint';
    uri = Uri.parse(url);

    try {
      final response = await RouteHandler.dio.get(url,
          data: jsonEncode(data),
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
      try {
        endPoint = '/getLanguageDictionary';
        url = '$defaultHost$endPoint';
        uri = Uri.parse(url);
        final response2 = await RouteHandler.dio.get(url);
        languageNames = json.decode(response2.data);
      } on DioException catch (e) {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {'message': 'post machine broke lil bro'},
          statusCode: 500,
        );
      }
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': 'post machine broke lil bro'},
        statusCode: 500,
      );
    }
  }
}
