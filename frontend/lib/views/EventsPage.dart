import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/classes/eventHelper.dart';
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
  //init
  @override
  void initState() {
    super.initState();
    EventHelper.mounted = true;
    EventHelper.fetchEvents(setState);
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

//I need to move this function to events helper where I can make
//the results memoized by hand since flutter hooks and memoization absolutelty failed me
  Widget _buildList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, index) {
        //if at bottom of list show loading indicator
        if (index == EventHelper.events.length) {
          if (EventHelper.fetched == true) {
            return null;
          }
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

  Widget _buildEvent(Map<String, String> event) {
    return GestureDetector(
      onTap: () => {
        _launchURL(Uri.parse(event['url']!)),
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
                        event['month']!,
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
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Divider()
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
        title: SearchBar(
          listSetState: setState,
          list: EventHelper.events,
        ),
        toolbarHeight: 40,
      ),
      body: _buildList(),
    );
  }
}

class SearchBar extends StatefulWidget {
  final Function listSetState;
  List list;
  final Function listFetcher;

  static dummyFetcher(String value) async {}

  SearchBar(
      {super.key,
      required this.listSetState,
      required this.list,
      this.listFetcher = dummyFetcher});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();
  final Set<dynamic> defaultList = {};

  @override
  void initState() {
    super.initState();
  }

  //what to do we want to do?

  void performSearch(String value) async {
    //add all items to set
    await addAllItemsToSet();
    print(value.length);
    print(defaultList.length);
    if (value.isEmpty) {
      widget.listSetState(() {
        widget.list.clear();
        for (var item in defaultList) {
          widget.list.add(item);
        }
      });
      return;
    }
    String type = inferListItemsType();
    List newList = [];
    if (type == "map") {
      //output, all strings in list
      for (var item in defaultList) {
        for (var entry in item.entries) {
          //lower case both values
          if (entry.value.toLowerCase().contains(value.toLowerCase())) {
            newList.add(item);
            break;
          }
        }
      }
      widget.list.clear();
      for (var item in newList) {
        widget.list.add(item);
      }
      print(widget.list);
      widget.listSetState(() {});
    }
  }

  String inferListItemsType() {
    if (defaultList.elementAt(0) is Map) {
      return "map";
    } else if (defaultList.elementAt(0) is String) {
      return "string";
    } else {
      //output error
      throw Exception("List items are not of type map or string");
    }
  }

  addAllItemsToSet() async {
    for (var item in widget.list) {
      defaultList.add(item);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        performSearch(_controller.text);
      },
      decoration: const InputDecoration(
        hintText: 'Search',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
