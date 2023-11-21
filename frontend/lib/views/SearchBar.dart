import 'package:flutter/material.dart';
import 'package:frontend/classes/Localize.dart';

class SearchBarWidget extends StatefulWidget {
  final Function listSetState;
  List list;
  final Function listFetcher;

  static dummyFetcher(String value) async {}

  SearchBarWidget(
      {super.key,
      required this.listSetState,
      required this.list,
      this.listFetcher = dummyFetcher});

  @override
  State<SearchBarWidget> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
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
    List newList = [];
    //output, all strings in list
    for (var item in defaultList) {
      for (var entry in item.entries) {
        //lower case both values
        if (entry.value is String) {
          if (entry.value.toLowerCase().contains(value.toLowerCase())) {
            newList.add(item);
            break;
          }
        }
      }
    }
    widget.list.clear();
    for (var item in newList) {
      widget.list.add(item);
    }
    widget.listSetState(() {});
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
      decoration: InputDecoration(
        hintText: Localize('Search'),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
