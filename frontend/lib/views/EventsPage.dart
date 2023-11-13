import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/routeHandler.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:html/parser.dart' show parse;
import 'package:url_launcher/url_launcher.dart';
import 'package:memoized/memoized.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  var _events = <Map<String, String>>[];

  //init
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

//I need to move this function to events helper where I can make
//the results memoized by hand since flutter hooks and memoization absolutelty failed me
  Future fetchEvents() async {
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
      var events = response.data;
      setState(() {
        for (var event in events) {
          DateTime dateTime = DateTime.parse(event['startDateTime']);
          _events.add({
            'title': unescape.convert(event['title']),
            'date': unescape.convert(event['dateTimeFormatted']),
            'location': parse(event['location']).body!.text,
            'day': dateTime.day.toString(),
            'month': monthsOfYear[dateTime.month]!,
            'url': event['permaLinkUrl'],
          });
        }
      });
      return response;
    } on DioException catch (e) {
      print(e);
      // Handle the error, you might want to throw an exception or return a default response
      throw e;
    }
  }

  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, item) {
        if (item.isOdd) return const Divider();

        final index = item ~/ 2;
        //if at bottom of list show loading indicator
        if (index == _events.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
          //right now the events are only 50 long so I return null
          //I am thinking of using a different api to get way more events will see later
        } else if (index >= _events.length) {
          return null;
        }
        return _buildEvent(_events[index]);
      },
    );
  }

  Widget _buildEvent(Map<String, String> event) {
    return GestureDetector(
      onTap: () => {
        _launchURL(Uri.parse(event['url']!)),
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  event['day']!,
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
                Text(
                  event['month']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    children: <Widget>[
                      Text(
                        "${event['title']}",
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "${event['date']}",
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        "${event['location']}",
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffece7d5),
      body: _buildList(),
    );
  }
}
