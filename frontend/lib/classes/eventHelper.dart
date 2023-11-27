import 'package:dio/dio.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart' show parse;

import 'package:frontend/classes/keywordData.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/localize.dart';

class EventHelper {
<<<<<<< HEAD
  static var events = <Map<String, String>>[];
=======
  static final events = <Map<String, dynamic>>[];
>>>>>>> origin/gabriel
  static bool mounted = true;
  static bool fetched = false;
  static String previousLanguage = "en";

  static Future fetchEvents(Function setState) async {
    if (events.isNotEmpty) {
      var language = AuthHelper.userInfoCache['language'];
      if (language == previousLanguage) {
        return;
      } else {
        EventHelper.fetched == false;
        events.clear();
      }
    }
    final monthsOfYear = {
      1: 'JAN',
      2: 'FEB',
      3: 'MAR',
      4: 'APR',
      5: 'MAY',
      6: 'JUN',
      7: 'JUL',
      8: 'AUG',
      9: 'SEP',
      10: 'OCT',
      11: 'NOV',
      12: 'DEC',
    };

    try {
      String defaultHost = RouteHandler.defaultHost;
      var language = AuthHelper.userInfoCache['language'];
      EventHelper.previousLanguage = language;
      print("language is $language");
      String endPoint = '/getEvents';
      final url = '$defaultHost$endPoint';
      var params = {
        'language': language,
      };
      final response = await RouteHandler.dio.get(url,
          queryParameters: params,
          options: Options(responseType: ResponseType.json));
      print(response);
      var results = response.data;

      final eventsSecondary = <Map<String, String>>[];

      //Okay so how are the events being set as recommended?
      if (mounted) {
        setState(() {
          for (var event in results) {
            if (isEventRecommended(event)) {
              events.add({
                'title': event['title'][language],
                'date': event['date'][language],
                'location': event['location'],
                'day': event['day'],
                'month': event['month'],
                'description': event['description'][language],
                'recommended': 'True',
<<<<<<< HEAD
                'id': event['eventID'].toString(),
=======
>>>>>>> origin/gabriel
              });
            } else {
              eventsSecondary.add({
                'title': event['title'][language],
                'date': event['date'][language],
                'location': event['location'],
                'day': event['day'],
                'month': event['month'],
                'description': event['description'][language],
                'recommended': 'false',
              });
            }
          }
          for (var event in eventsSecondary) {
            events.add(event);
          }
        });
      }
      fetched = true;
      return response;
    } on DioException catch (e) {
      print(e);
      // Handle the error, you might want to throw an exception or return a default response
      throw e;
    }
  }

  static bool isEventRecommended(var event) {
    var language = AuthHelper.userInfoCache['language'];
    String eventTitle = event['title']["en"];
    String eventDescription = event['description']["en"];
    String userNationality = AuthHelper.userInfoCache['nationality'];
    List? userKeywords = keywordData.countryKeywords[userNationality];
    userNationality = userNationality.toLowerCase();
    String userLanguage =
        AuthHelper.languageNames[AuthHelper.userInfoCache['language']];
    userLanguage = userLanguage.toLowerCase();
    if (eventTitle.contains(userNationality) ||
        eventDescription.contains(userNationality)) {
      return true;
    }
    if (eventTitle.contains(userLanguage) ||
        eventDescription.contains(userLanguage)) {
      return true;
    }
    if (userKeywords == null) {
      userKeywords = [];
    }
    for (String keyword in userKeywords) {
      if (eventTitle.contains(keyword.toLowerCase()) ||
          eventDescription.contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}
