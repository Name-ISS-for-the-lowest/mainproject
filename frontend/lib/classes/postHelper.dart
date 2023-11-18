import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:frontend/classes/authHelper.dart';

class PostHelper {
  static String defaultHost = RouteHandler.defaultHost;
  static Map<String, String> cachedTranslations = Map();

  static Future<Response> createPost(String userID, String postBody) async {
    final params = {'postBody': postBody};
    String endPoint = '/createPost';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
          queryParameters: params,
          options: Options(contentType: Headers.jsonContentType));
      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }

  static getPosts(int start, int end) async {
    final params = {
      'start': start,
      'end': end,
    };
    String endPoint = '/getPosts';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.get(url,
          queryParameters: params,
          options: Options(contentType: Headers.jsonContentType));
      return response.data;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }

  static getTranslation(String input) async {
    String targetLang = AuthHelper.userInfoCache['language'];
    print(targetLang);
    final params = {'target': targetLang, 'content': input};
    String endPoint = '/translate';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.get(url,
          queryParameters: params,
          options: Options(contentType: Headers.jsonContentType));
      return response.data;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }

  static storeTranslation(String translatedText, String postID) async {
    String userLang = AuthHelper.userInfoCache['language'];
    final params = {
      'translatedText': translatedText,
      'userLang': userLang,
      'postID': postID
    };
    String endPoint = '/addTranslation';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
          queryParameters: params,
          options: Options(contentType: Headers.jsonContentType));
      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }
}
