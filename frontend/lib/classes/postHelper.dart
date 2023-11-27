import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/routeHandler.dart';

class PostHelper {
  static String defaultHost = RouteHandler.defaultHost;
  static Map<String, String> cachedTranslations = {};

  static Future<Response> createPost(
      String userID, String postBody, File? Photo) async {
    Map<String, dynamic> params;
    String endPoint;
    String? imageURL;
    String? fileID;
    String url;
    if (Photo != null) {
      var formData = FormData.fromMap({
        'photo': await MultipartFile.fromFile(Photo.path,
            filename: AuthHelper.userInfoCache['username'] + '_postAttachment'),
      });
      params = {
        'name': AuthHelper.userInfoCache['username'],
        'type': 'postAttachments'
      };
      endPoint = '/uploadPhoto';
      url = '$defaultHost$endPoint';
      try {
        final response = await RouteHandler.dio.post(url,
            data: formData,
            queryParameters: params,
            options:
                Options(contentType: Headers.multipartFormDataContentType));
        imageURL = response.data['url'];
        fileID = response.data['fileId'];
      } on DioException catch (e) {
        return Response(
          requestOptions: RequestOptions(path: url),
          data: {'message': e},
          statusCode: 500,
        );
      }
    }
    endPoint = '/createPost';
    url = '$defaultHost$endPoint';
    params = {
      'postBody': postBody,
      'imageURL': 'False',
      'imageFileID': 'False'
    };
    if (imageURL != null) {
      params['imageURL'] = imageURL;
      params['imageFileID'] = fileID;
    }

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

  static Future<Response> editPost(String postID, String postBody) async {
    final params = {'postID': postID, 'postBody': postBody};
    String endPoint = '/editPost';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
          queryParameters: params,
          options: Options(contentType: Headers.jsonContentType));
      return response;
    } on DioException catch (e) {
      print(e);
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': e},
        statusCode: 500,
      );
    }
  }

  static Future<Response> deletePost(String postID) async {
    final params = {'postID': postID};
    String endPoint = '/deletePost';
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

  static Future<Response> toggleRemoval(String postID) async {
    final params = {'postID': postID};
    String endPoint = '/toggleRemovalOfPost';
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

  static getPosts(int start, int end,
      [Map<String, String>? specialSearchOptions]) async {
    specialSearchOptions ??= {
        'showReported': 'All',
        'showRemoved': 'None',
        'showDeleted': 'None'
      };
    final params = {
      'start': start,
      'end': end,
      'showReported': specialSearchOptions['showReported'],
      'showRemoved': specialSearchOptions['showRemoved'],
      'showDeleted': specialSearchOptions['showDeleted'],
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

  static getPostByID(String postID) async {
    final params = {
      'postID': postID,
    };
    String endPoint = '/getPostByID';
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

  static searchPosts(int start, int end, String search, String userID,
      [Map<String, String>? specialSearchOptions]) async {
    specialSearchOptions ??= {
        'showReported': 'All',
        'showRemoved': 'None',
        'showDeleted': 'None'
      };
    final data = {
      'start': start,
      'end': end,
      'search': search,
      'userID': userID,
      'showReported': specialSearchOptions['showReported'],
      'showRemoved': specialSearchOptions['showRemoved'],
      'showDeleted': specialSearchOptions['showDeleted'],
    };
    String endPoint = '/searchPosts';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
          data: jsonEncode(data),
          options: Options(contentType: Headers.jsonContentType));
      return response.data;
    } on DioException {
      return Response(
        requestOptions: RequestOptions(path: url),
        data: {'message': 'post machine broke lil bro'},
        statusCode: 500,
      );
    }
  }

  static likePost(String postID) async {
    final params = {'postID': postID};
    String endPoint = '/likePost';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
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

  static reportPost(String postID, Map<String, bool> reasonsSelected) async {
    final params = {
      'postID': postID,
      'hateSpeech': reasonsSelected['hateSpeech'].toString(),
      'illegalContent': reasonsSelected['illegalContent'].toString(),
      'targetedHarassment': reasonsSelected['targetedHarassment'].toString(),
      'inappropriateContent':
          reasonsSelected['inappropriateContent'].toString(),
      'otherReason': reasonsSelected['otherReason'].toString()
    };
    String endPoint = '/reportPost';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(url,
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
