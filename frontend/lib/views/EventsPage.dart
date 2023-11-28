import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/classes/Localize.dart';
import 'package:frontend/classes/authHelper.dart';
import 'package:frontend/classes/eventHelper.dart';
import 'package:frontend/views/SearchBar.dart';
import 'package:url_launcher/url_launcher.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  //init
  @override
  void initState() {
    super.initState();
    EventHelper.mounted = true;
    EventHelper.setState = setState;
    EventHelper.fetchEvents();
  }

  @override
  void dispose() {
    super.dispose();
    EventHelper.mounted = false;
  }

  Future<void> _launchURL(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  void showExpandedInformation(Map<String, dynamic> event, String? eventId) {
    print(event);
    var language = AuthHelper.userInfoCache['language'];
    var url =
        "https://events-csus-edu.translate.goog/?eventid=$eventId&_x_tr_sl=auto&_x_tr_tl=$language";
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xffece7d5),
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      String? eventId = event['id'];
                      var language = AuthHelper.userInfoCache['language'];
                      var url = Navigator.of(context).pop();
                    },
                    child: Container(
                      width: 300,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            child: const Icon(Icons.close),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(Localize("Close Screen")),
                        ],
                      ),
                    ),
                  ),
                  Row(children: [
                    Expanded(
                        child: Text(
                      event['title']!,
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ]),
                  const SizedBox(height: 10.0),
                  Text(
                    event['date']!,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    event['location']!,
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    event['description']!,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          String? eventId = event['id'];
                          var language = AuthHelper.userInfoCache['language'];
                          var url =
                              "https://events-csus-edu.translate.goog/?eventid=$eventId&_x_tr_sl=auto&_x_tr_tl=$language";
                          _launchURL(Uri.parse(url));
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 8, bottom: 8, left: 16, right: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(color: Colors.black, width: 1.0),
                            color: Colors.white,
                          ),
                          child: Text(
                            Localize('Open Translated Website'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

//I need to move this function to events helper where I can make
//the results memoized by hand since flutter hooks and memoization absolutelty failed me
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        //if at bottom of list show loading indicator
        if (index == EventHelper.events.length) {
          return const Center(
            child: CircularProgressIndicator(),
          );
          //right now the events are only 50 long so I return null
          //I am thinking of using a different api to get way more events will see later
        } else if (index >= EventHelper.events.length) {
          return null;
        }
        return _buildEvent(EventHelper.events[index]);
      },
    );
  }

  Widget _buildEvent(Map<String, dynamic> event) {
    String? eventId = event['id'];
    return GestureDetector(
      onTap: () {
        showExpandedInformation(event, eventId);
      },
      child: Column(
        children: [
          Row(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        event['day']!,
                        style: const TextStyle(
                          fontSize: 27,
                        ),
                      ),
                      Text(
                        Localize(event['month']!),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
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
                            // maxLines: 1,
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              // overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "${event['date']}",
                            // maxLines: 4,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            "${event['location']}",
                            // maxLines: 2,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              // overflow: TextOverflow.ellipsis
                            ),
                          ),
                          (event['recommended'] == 'True')
                              ? Row(
                                  children: [
                                    Text(
                                      Localize("Recommended for you!"),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.red),
                                    ),
                                    SvgPicture.asset(
                                      'assets/light-bulb.svg',
                                      height: 25,
                                      width: 25,
                                      color: Colors.red,
                                    )
                                  ],
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffece7d5),
      appBar: AppBar(
        backgroundColor: const Color(0xffece7d5),
        automaticallyImplyLeading: false,
        title: SearchBarWidget(
          listSetState: setState,
          list: EventHelper.events,
        ),
        toolbarHeight: 40,
      ),
      body: _buildList(),
    );
  }
}
