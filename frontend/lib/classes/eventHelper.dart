import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:frontend/classes/keywordData.dart';
import 'package:frontend/classes/authHelper.dart';

class EventHelper {
  static final events = <Map<String, dynamic>>[];
  static bool mounted = true;
  static bool fetched = false;
  static bool fetching = false;
  static Function setState = () {};
  static String previousLanguage = "en";

  static Future fetchEvents() async {
    if (events.isNotEmpty) {
      var language = AuthHelper.userInfoCache['language'];
      if (language == previousLanguage) {
        return;
      } else {
        EventHelper.fetched == false;
        events.clear();
      }
    }
    try {
      if (fetching) {
        return;
      }
      EventHelper.fetching = true;
      String defaultHost = RouteHandler.defaultHost;
      var language = AuthHelper.userInfoCache['language'];
      EventHelper.previousLanguage = language;
      String endPoint = '/getEvents';
      final url = '$defaultHost$endPoint';
      var params = {
        'language': language,
      };
      final response = await RouteHandler.dio.get(url,
          queryParameters: params,
          options: Options(responseType: ResponseType.json));
      var results = response.data;
      results = jsonDecode(results);

      final eventsSecondary = <Map<String, String>>[];

      //Okay so how are the events being set as recommended?
      if (mounted) {
        EventHelper.setState(() {
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
                'id': event['id'].toString(),
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
                'id': event['id'].toString(),
              });
            }
          }
          print("printing events");
          print(events);
          print("printing secondary events");
          print(eventsSecondary);
          for (var event in eventsSecondary) {
            events.add(event);
          }
        });
      }

      fetched = true;
      fetching = false;
      return response;
    } on DioException catch (e) {
      //sc
      print("had an error");
      print(e);
      // Handle the error, you might want to throw an exception or return a default response
      rethrow;
    }
  }

  static bool isEventRecommended(var event) {
    String eventTitle = event['title']["en"];
    String eventDescription = event['description']["en"];
    eventTitle = eventTitle.toLowerCase();
    eventDescription = eventDescription.toLowerCase();
    print("Nationality");
    print(AuthHelper.userInfoCache['nationality']);

    List userKeywords = [];
    String userNationality = "N\\A";
    if (AuthHelper.userInfoCache.containsKey('nationality')) {
      userKeywords =
          keywordData.countryKeywords[AuthHelper.userInfoCache['nationality']]!;
      userNationality = AuthHelper.userInfoCache['nationality'];
    }

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

    for (String keyword in userKeywords) {
      if (eventTitle.toLowerCase().contains(keyword.toLowerCase()) ||
          eventDescription.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}
