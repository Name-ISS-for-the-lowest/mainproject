import 'dart:convert';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import 'package:frontend/classes/routeHandler.dart';

class PostHelper {
  static String defaultHost = RouteHandler.defaultHost;
  static Map<String, String> cachedTranslations = Map();

  static Future<Response> createPost(String userID, String postBody) async {
    final data = {'userID': userID, 'postBody': postBody};
    String endPoint = '/createPost';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
          data: jsonEncode(data),
          options: Options(contentType: Headers.jsonContentType));
      return response;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': 'post machine broke lil bro'},
        statusCode: 500,
      );
    }
  }

  static getPosts(int start, int end) async {
    final data = {'start': start, 'end': end};
    String endPoint = '/getPosts';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.get(url,
          data: jsonEncode(data),
          options: Options(contentType: Headers.jsonContentType));
      return response.data;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': 'post machine broke lil bro'},
        statusCode: 500,
      );
    }
  }

  static getTranslation(String input) async {
    final data = {'source': 'en', 'target': 'es', 'content': input};
    String endPoint = '/translate';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.get(url,
          data: jsonEncode(data),
          options: Options(contentType: Headers.jsonContentType));
      return response.data;
    } on DioException catch (e) {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': 'post machine broke lil bro'},
        statusCode: 500,
      );
    }
  }
}