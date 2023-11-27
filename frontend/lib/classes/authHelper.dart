import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/classes/Data.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:intl/intl.dart';

//todo add persitent storage for session cookie

class AuthHelper {
  static String defaultHost = RouteHandler.defaultHost;
  static Map<String, dynamic> userInfoCache = {};
  static Map<String, dynamic> languageNames = Data.languageNames;

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

//need reset password function
  static Future<Response> resetPassword(String email) async {
    final params = {'email': email};
    String endPoint = '/resetPassword';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(
        url,
        queryParameters: params,
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

  static Future<Response> logout() async {
    String endPoint = '/logout';
    var url = '$defaultHost$endPoint';

    //this is the dio library making a post request
    try {
      final response = await RouteHandler.dio.post(url);
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
    // return false;
    var sessionCookie = await readCookie('session_cookie');
    if (sessionCookie == null) return false;

    //I want to make a request to the protected endpoint and check the response code
    String endPoint = '/protected';
    var url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.get(
        url,
        options: Options(contentType: Headers.jsonContentType),
      );
      if (response.statusCode == 200) {
        await cacheUserInfo();
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        return false;
      } else {
        return false;
      }
    }
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
      AuthHelper.userInfoCache['_id'] = userInfo['_id'];
      AuthHelper.userInfoCache['email'] = userInfo['email'];
      AuthHelper.userInfoCache['username'] = userInfo['username'];
      AuthHelper.userInfoCache['language'] = userInfo['language'];
      AuthHelper.userInfoCache['nationality'] = userInfo['nationality'];
      AuthHelper.userInfoCache['profilePicture.url'] =
          userInfo['profilePicture.url'];
      AuthHelper.userInfoCache['profilePicture.fileId'] =
          userInfo['profilePicture.fileId'];
      userInfoCache['admin'] = userInfo['admin'];
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }

  static Future<Response> updateUser() async {
    final data = {
      'id': userInfoCache['_id'],
      'email': userInfoCache['email'],
      'username': userInfoCache['username'],
      'language': userInfoCache['language'],
      'nationality': userInfoCache['nationality'],
      'profilePictureURL': userInfoCache['profilePicture.url'],
      'profilePictureFileID': userInfoCache['profilePicture.fileId'],
    };
    String endPoint = '/updateUser';
    var url = '$defaultHost$endPoint';

    //this is the dio library making a post request
    try {
      final response = await RouteHandler.dio.post(
        url,
        data: jsonEncode(data),
        options: Options(contentType: Headers.jsonContentType),
      );
      return response;

      //on anything but a 200 response this code will run
    } on DioException catch (e) {
      print(e);
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

  static setProfilePicture(File photo) async {
    var sessionCookie = await readCookie('session_cookie');
    String userID = sessionCookie['user_id'];
    String endPoint = '/uploadPhoto';
    var url = '$defaultHost$endPoint';
    String name = userInfoCache['email'] + "_profilePicture";

    var formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(photo.path, filename: name),
    });
    var params = {
      'name': name,
      'type': 'profilePictures',
    };

    try {
      final response = await RouteHandler.dio.post(url,
          data: formData,
          queryParameters: params,
          options: Options(contentType: Headers.multipartFormDataContentType));
      return response.data;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }

  static setProfilePictureOnSignUp(String email, File photo) async {
    //this endpoint can change a profile picture, but email, only if account is unverified
    String endPoint = '/setProfilePictureOnSignUp';
    var url = '$defaultHost$endPoint';

    var formData = FormData.fromMap({
      'photo': await MultipartFile.fromFile(photo.path),
    });
    var params = {
      'email': email,
    };

    try {
      final response = await RouteHandler.dio.post(url,
          data: formData,
          queryParameters: params,
          options: Options(contentType: Headers.multipartFormDataContentType));
      return response.data;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }
}
