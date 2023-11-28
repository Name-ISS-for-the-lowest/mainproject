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
      print(e);
      // Handle the error, you might want to throw an exception or return a default response
      rethrow;
    }
  }

  static bool isEventRecommended(var event) {
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
    userKeywords ??= [];
    userKeywords =
        keywordData.countryKeywords[AuthHelper.userInfoCache['nationality']]!;
    for (String keyword in userKeywords) {
      if (eventTitle.toLowerCase().contains(keyword.toLowerCase()) ||
          eventDescription.toLowerCase().contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }
}
