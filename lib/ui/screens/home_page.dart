import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elzwelle_start/models/timestamp_entity.dart';
import 'package:elzwelle_start/ui/screens/add_page.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/controls/course_input.dart';

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  final MqttHandler         mqttHandler;
  final ModeRadioListSelection  mode;

  int modeIndex = -1;

  HomePage({
    Key? key,
    required this.mqttHandler,
    required this.mode
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();
  final List<TimestampEntity> _timestamps  =  List.filled(0, TimestampEntity(time: '00:00:00', stamp: '0.00', number: '0',tag: '*'), growable: true);

  bool _tag(String stamp, String tag) {
    TimestampEntity _item;

    for (_item in _timestamps ) {
      if ( _item.stamp == stamp ) {
        _item.tag = tag;
        return true;
      }
    }
    return false;
  }

  bool _num(String stamp, String num) {
    TimestampEntity _item;

    for (_item in _timestamps ) {
      if ( _item.stamp == stamp ) {
        _item.number = num;
        return true;
      }
    }
    return false;
  }
  
  void _update(String s) {
    var _items = s.split(' ');
    // check for tree items, drop other messages
    if (_items.length > 2) {
      var idx = _items.length - 1;
      if (_items[idx] == '*') {
        _timestamps.insert(0, TimestampEntity(
            time: _items[0], stamp: _items[1], number: _items[2], tag: _items[idx]));
        if (kDebugMode) {
          print('Insert length: ${_timestamps.length}');
        }
      } else if (_items[idx] == '#') {
        if (kDebugMode) {
          print('Update AKN Tag');
        }
        _tag(_items[1],_items[idx]);
        _num(_items[1],_items[2]);
      } else if (_items[3] == '!') {
        if (kDebugMode) {
          print('Update ERROR Tag');
        }
        _tag(_items[1],_items[idx]);
      }
    }
  }

  void scrollDown() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(HOME_PAGE_TITLE[widget.mode.index]),
        backgroundColor: Colors.lightBlue,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: ModeRadioListMode(radioList: widget.mode),
              )
            ]
          )
        ],
      ),
      body: Container(
        child: () { // anonymous function
          //print('Index: ${widget.mode.index}');
          if (widget.mode.index <= 1) { // then container
            // anonymous function return Widget
            return ValueListenableBuilder<String>(
              builder: (BuildContext context, String value, Widget? child) {
                if (widget.modeIndex != widget.mode.index) {
                  _timestamps.clear();
                  widget.modeIndex = widget.mode.index;
                  if (kDebugMode) {
                    print('Clear, Mode: ${widget.mode.index}');
                  }
                  value = '';
                } else {
                  if (kDebugMode) {
                    print('Notify: $value ');
                  }
                  _update(value);
                }
                widget.mqttHandler.data.value = '';

                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: _timestamps.length,
                        itemBuilder: (context, i) {
                          return TimestampCard(
                            mode: widget.mode,
                            timestamp: _timestamps[i],
                            mqttHandler: widget.mqttHandler,
                          );
                        },  // itemBuilder
                      ),
                    ),
                  ]
                );
              }, // builder
              valueListenable: widget.mqttHandler.data,
            );
          } else { // else container
            return Center(
                  child: CourseInput(mqttHandler: widget.mqttHandler),
                );
          }  // end container
        }() // anonymous function
      )
    );
  } // build

} // class

class TimestampCard extends StatelessWidget {
  final TimestampEntity     timestamp;
  final MqttHandler         mqttHandler;
  final ModeRadioListSelection  mode;

  const TimestampCard({
    required this.mqttHandler,
    required this.timestamp,
    required this.mode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle;

    switch(timestamp.tag) {
      case '*': {
        _textStyle = const TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold,
            color: Colors.grey,
        );
      }
      break;
      case '#': {
        _textStyle = const TextStyle(
            fontSize: 20.0, fontWeight: FontWeight.bold,
            color: Colors.green,
        );
      }
      break;
      case '?': {
        _textStyle = const TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold,
          color: Colors.cyan,
        );
      }
      break;
      case '!': {
        _textStyle = const TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold,
          color: Colors.red,
        );
      }
      break;
      default: {
        _textStyle = const TextStyle(
          fontSize: 20.0, fontWeight: FontWeight.bold,
          color: Colors.black12,
        );
      }
      break;
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child:
                Text(timestamp.time,
                  style: _textStyle,
                  textAlign: TextAlign.start,
                ),
              ),
            Expanded(
              child:
                Text(timestamp.stamp,
                    style: _textStyle,
                    textAlign: TextAlign.start),
            ),
            Expanded(
              child:
              Text(timestamp.number,
                  style: _textStyle,
                  textAlign: TextAlign.start),
            ),
            Center(
              child: IconButton(
                icon: const Icon(
                  Icons.edit,
                  color: Colors.lightBlue,
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPage(
                          mode: mode,
                          timestamp:  timestamp,
                          mqttHandler: mqttHandler,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  } // build

} // class

