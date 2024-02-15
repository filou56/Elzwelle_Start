import 'dart:core';
import 'package:flutter/material.dart';
import 'package:elzwelle_start/models/timestamp_entity.dart';
import 'package:elzwelle_start/ui/screens/add/add_page.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/controls/drop_down.dart';

class HomePage extends StatefulWidget {
  final MqttHandler mqttHandler;
  final RadioListValue mode;

  const HomePage({
    Key? key,
    required this.mqttHandler,
    required this.mode
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final ScrollController _scrollController = ScrollController();
  final List<TimestampEntity> _timestamps =  List.filled(0, TimestampEntity(time: '00:00:00', stamp: '0.00', number: '0',tag: '*'), growable: true);

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
  
  void _update(String s) {
    var _items = s.split(' ');
    // print('S: ${s}');
    // print('Tag: ${items[3]}');

    // check for tree items, drop other messages
    if (_items.length == 4) {
      if (_items[3] == '*') {
        //timestamps.add(TimestampEntity(time: items[0], stamp: items[1], number: items[2]));
        _timestamps.insert(0, TimestampEntity(
            time: _items[0], stamp: _items[1], number: _items[2], tag: _items[3]));
        print('Insert length: ${_timestamps.length}');
      } else if (_items[3] == '#') {
        print('Update AKN Tag');
        _tag(_items[1],_items[3]);
      } else if (_items[3] == '!') {
        print('Update ERROR Tag');
        _tag(_items[1],_items[3]);
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
        title: const Text('Timestamps Start'),
        //backgroundColor: Colors.lightBlue,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: RadioListMode(value: widget.mode),
              )
            ]
          )
        ],
      ),
      body: ValueListenableBuilder<String>(
        builder: (BuildContext context, String value, Widget? child) {
          print('Notify: $value Mode: ${widget.mode.index}');
          if (value.isNotEmpty) {
            _update(value);
          }
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
                      timestamp: _timestamps[i],
                      mqttHandler: widget.mqttHandler,
                    );
                  },
                ),
              ),
            ]
          );
        },
        valueListenable: widget.mqttHandler.data,
      ),
    );
  } // build

} // class

class TimestampCard extends StatelessWidget {
  final TimestampEntity _timestamp;
  final MqttHandler _mqttHandler;

  const TimestampCard({
    required MqttHandler mqttHandler,
    required TimestampEntity timestamp,
    Key? key,
  }) : _mqttHandler = mqttHandler, _timestamp = timestamp, super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle;

    switch(_timestamp.tag) {
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
                Text(_timestamp.time,
                  style: _textStyle,
                  textAlign: TextAlign.start,
                ),
              ),
            Expanded(
              child:
                Text(_timestamp.stamp,
                    style: _textStyle,
                    textAlign: TextAlign.start),
            ),
            Expanded(
              child:
              Text(_timestamp.number,
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
                          timestamp:  _timestamp,
                          mqttHandler: _mqttHandler,
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

