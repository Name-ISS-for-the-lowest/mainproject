import 'package:dio/dio.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart' show parse;
import 'package:frontend/classes/Data.dart';
import 'package:frontend/classes/authHelper.dart';

class EventHelper {
  static final events = <Map<String, String>>[];
  static bool mounted = true;
  static bool fetched = false;

  static Future fetchEvents(Function setState) async {
    if (events.isNotEmpty) {
      return;
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
      var unescape = HtmlUnescape();
      var url = "https://www.trumba.com/calendars/sacramento-state-events.json";
      final response = await RouteHandler.dio.get(url);
      var results = response.data;
      final eventsSecondary = <Map<String, String>>[];

      //I need to fix the set state bug, if you click to another page while events are fetching,
      //an error will be thrown because set state is called on an non-existent widget, RIP.
      if (mounted) {
        setState(() {
          for (var event in results) {
            if (isEventRecommended(event)) {
              DateTime dateTime = DateTime.parse(event['startDateTime']);
              events.add({
                'title': unescape.convert(event['title']),
                'date': unescape.convert(event['dateTimeFormatted']),
                'location': parse(event['location']).body!.text,
                'day': dateTime.day.toString(),
                'month': monthsOfYear[dateTime.month]!,
                'url': event['permaLinkUrl'],
                'description': _parseHtmlString(event['description']),
                'recommended': 'True',
              });
            } else {
              DateTime dateTime = DateTime.parse(event['startDateTime']);
              eventsSecondary.add({
                'title': unescape.convert(event['title']),
                'date': unescape.convert(event['dateTimeFormatted']),
                'location': parse(event['location']).body!.text,
                'day': dateTime.day.toString(),
                'month': monthsOfYear[dateTime.month]!,
                'url': event['permaLinkUrl'],
                'description': _parseHtmlString(event['description']),
                'recommended': 'False',
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
    var unescape = HtmlUnescape();
    String eventTitle = unescape.convert(event['title']).toLowerCase();
    String eventDescription =
        _parseHtmlString(event['description']).toLowerCase();
    String userNationality = AuthHelper.userInfoCache['nationality'];
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
    List? userKeywords = Data.countryKeywords[userNationality];
    if (userKeywords == null) {
      userKeywords = [];
    }
    for (String keyword in userKeywords) {
      if (eventTitle.contains(keyword) || eventDescription.contains(keyword)) {
        return true;
      }
    }
    return false;
  }

  static String _parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    if (document.body == null) return '';
    final String? parsedString =
        parse(document.body?.text).documentElement?.text;
    if (parsedString == null) return htmlString;
    return parsedString;
  }
}
