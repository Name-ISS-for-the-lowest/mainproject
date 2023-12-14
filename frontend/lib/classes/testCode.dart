import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:frontend/classes/postHelper.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:math';

class testCode {
  static String defaultHost = RouteHandler.defaultHost;

  static testTranslationStorage() async {
    print('TEST CODE BEING RAN: testTranslationStorage');
    var postID = '657a35d8eb391a5a3d36cc0c';
    var languagesToTest = [
      'ar',
      'ja',
      'de',
      'es',
      'fr',
      'zh-TW',
      'el',
      'ko',
      'uk',
      'th'
    ];
    var post = await PostHelper.getPostByID(postID);
    String postContent = post['content'];
    for (String language in languagesToTest) {
      print('TRANSLATION BEGIN WITH CODE: ' + language);
      var translationCall =
          await modifiedFunctions.getTranslation(postContent, language);
      String translation = translationCall['result'];
      await modifiedFunctions.storeTranslation(translation, postID, language);
    }
  }

  static testReadingUserData() async {
    print('TEST CODE BEING RAN: testReadingUserData');
    var usersToLoad = [
      '655007dd8b56155f6e11fb55',
      '655007e78b56155f6e11fb56',
      '655007ee8b56155f6e11fb57',
      '655007f78b56155f6e11fb58',
      '655007ff8b56155f6e11fb59'
    ];
    for (String user in usersToLoad) {
      var userCall = await PostHelper.getUserByID(user);
      print('Successfully Read User!');
      print('User Email: ' + userCall['email']);
      print('User Screenname: ' + userCall['username']);
      print('Profile Picture URL: ' + userCall['profilePicture.url']);
      print('Nationality: ' + userCall['nationality']);
      print('Preferred Language: ' +
          AuthHelper.languageNames[userCall['language']]);
    }
  }

  static testReadingPostData() async {
    var postIDs = [
      '657a35d8eb391a5a3d36cc0c',
      '6567f1a6cf04cbff6b1208fb',
      '6567f0d1e39eca76a16e16d9',
      '657a4b54e8d3801c228ad1f7',
      '655311f85975024918521368'
    ];
    print('TEST CODE BEING RAN: testReadingPostData');
    for (String post in postIDs) {
      var postData = await PostHelper.getPostByID(post);
      print('Post Successfully Read!');
      print('Poster Username : ' + postData['username']);
      print('Poster Email: ' + postData['email']);
      print('Poster Profile Picture URL: ' + postData['profilePicture']['url']);
      print('Post Content: ' + postData['content']);
      String imageURL;
      if (postData['attachedImage'] is Map) {
        imageURL = postData['attachedImage']['url'];
      } else {
        imageURL = postData['attachedImage'];
      }
      print('Attached Image Url : ' + imageURL);
    }
  }

  static testCreatingUsers() async {
    print('TEST CODE BEING RAN: testCreatingUsers');
    var userEmails = [
      'MrPerfect@fakeDomainForExamples.com',
      'iHatePickles@fakeDomainForExamples.com',
      'barkbark@fakeDomainForExamples.com',
      'ohmsLaw@fakeDomainForExamples.com',
      'nikolaTesla20000@fakeDomainForExamples.com'
    ];

    var userPasswords = [
      'password1',
      'password2',
      'password3',
      'password4',
      'password5'
    ];

    var defaultLanguages = ['en', 'ar', 'ja', 'de', 'pt'];

    for (int i = 0; i <= 4; i++) {
      String selectedEmail = userEmails[i];
      String selectedPassword = userPasswords[i];
      String selectedLanguage = defaultLanguages[i];
      var response = await modifiedFunctions.signUp(
          selectedEmail, selectedPassword, selectedLanguage);
    }
  }

  static testModifyingUsers() async {
    print('TEST CODE BEING RAN: testModifyingUsers');
    var userIDs = [
      '657a5196e8d3801c228ad1f8',
      '657a5197e8d3801c228ad1f9',
      '657a5198e8d3801c228ad1fa',
      '657a519ae8d3801c228ad1fb',
      '657a519be8d3801c228ad1fc'
    ];

    var userNamesToUpdate = [
      'I Like Turtles',
      'Literally Harambe',
      'Future F1 Driver',
      'Elmo',
      'Darth Vader'
    ];

    var nationalitiesToUpdate = [
      'Japan',
      'Canada',
      'India',
      'Ukraine',
      'Vietnam'
    ];

    var langaugesToUpdate = ['zh-TW', 'th', 'il', 'sv', 'no'];

    for (int i = 0; i <= 4; i++) {
      String selectedID = userIDs[i];
      String selectedName = userNamesToUpdate[i];
      String selectedNationality = nationalitiesToUpdate[i];
      String selectedLanguage = langaugesToUpdate[i];
      var response = await modifiedFunctions.updateUser(
          selectedID, selectedName, selectedLanguage, selectedNationality);
    }
  }

  static testingReports() async {
    print('TEST CODE BEING RAN: testingReports');
    final random = Random();

    var postsToReport = [
      '657a4b54e8d3801c228ad1f7',
      '657a35d8eb391a5a3d36cc0c'
    ];

    Map<String, bool> reasonsSelected = {};
    Map<int, bool> rollToBool = {0: false, 1: true};

    for (String post in postsToReport) {
      int reportsToGenerate = random.nextInt(5) + 5;
      for (int i = 0; i <= reportsToGenerate; i++) {
        int hateSpeechRoll = random.nextInt(2);
        int illegalContentRoll = random.nextInt(2);
        int targetedHarassmentRoll = random.nextInt(2);
        int inappropriateContentRoll = random.nextInt(2);
        int otherReasonRoll = random.nextInt(2);

        reasonsSelected = {
          'hateSpeech': rollToBool[hateSpeechRoll]!,
          'illegalContent': rollToBool[illegalContentRoll]!,
          'targetedHarassment': rollToBool[targetedHarassmentRoll]!,
          'inappropriateContent': rollToBool[inappropriateContentRoll]!,
          'otherReason': rollToBool[otherReasonRoll]!
        };

        await PostHelper.reportPost(post, reasonsSelected);
      }
    }
  }
}

class modifiedFunctions {
  static String defaultHost = RouteHandler.defaultHost;
  //A SLIGHTLY Modified version of our actual getTranslation code that takes target language as a parameter instead of automatically getting it.
  static getTranslation(String input, String targetLang) async {
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

  //A SLIGHTLY Modified version of our actual store translation that takes userLang as a parameter instead of automatically getting it.
  static storeTranslation(
      String translatedText, String postID, String userLang) async {
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

  //A SLIGHTLY Modified version of our actual signUp that takes defaultLang as a parameter instead of automatically getting it.
  static Future<Response> signUp(
      String email, String password, String defaultLang) async {
    final data = {'email': email, 'password': password};
    var params = {
      'language': defaultLang,
    };
    String endPoint = '/signup';
    final url = '$defaultHost$endPoint';
    try {
      final response = await RouteHandler.dio.post(
        url,
        data: jsonEncode(data),
        queryParameters: params,
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

  //A slightly modified version of our updateUser function that manually takes parameters instead of automatically gathering them
  static Future<Response> updateUser(String userID, String username,
      String language, String nationality) async {
    var userCall = await PostHelper.getUserByID(userID);
    final data = {
      'id': userID,
      'email': userCall['email'],
      'username': username,
      'language': language,
      'nationality': nationality,
      'profilePictureURL': userCall['profilePicture.url'],
      'profilePictureFileID': userCall['profilePicture.fileId'],
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
}
