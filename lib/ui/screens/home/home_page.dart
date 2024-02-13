import 'dart:core';
import 'package:flutter/material.dart';
import 'package:elzwelle_start/models/timestamp_entity.dart';
import 'package:elzwelle_start/ui/screens/add/add_page.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';

class HomePage extends StatelessWidget {
  final MqttHandler mqttHandler;
  final ScrollController scrollController = ScrollController();

  HomePage({
    required this.mqttHandler,
    Key? key,
  }) : super(key: key);

  final List<TimestampEntity> timestamps =  List.filled(0, TimestampEntity(time: '00:00:00', stamp: '0.00', number: '0'), growable: true);

  void append(String s) {
    var items = s.split(' ');
    // check for tree items, drop other messages
    if (items.length == 3) {
      //timestamps.add(TimestampEntity(time: items[0], stamp: items[1], number: items[2]));
      timestamps.insert(0,TimestampEntity(time: items[0], stamp: items[1], number: items[2]));
      print('Length: ${timestamps.length}');
    }
  }

  void scrollDown() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timestamps Start'),
        //backgroundColor: Colors.lightBlue,
      ),
      body: ValueListenableBuilder<String>(
        builder: (BuildContext context, String value, Widget? child) {
          print('Notify: $value');
          if (value.isNotEmpty) {
            append(value);
          }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: timestamps.length,
                itemBuilder: (context, i) {
                  return TimestampCard(
                      timestamp: timestamps[i],
                      mqttHandler: mqttHandler,
                    );
                  },
                ),
              ),
            ]
          );
        },
        valueListenable: mqttHandler.data,
      ),
    );
  } // build

} // class

class TimestampCard extends StatelessWidget {
  final TimestampEntity timestamp;
  final MqttHandler mqttHandler;

  const TimestampCard({
    required this.mqttHandler,
    required this.timestamp,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child:
                Text(timestamp.time,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
              ),
            Expanded(
              child:
                Text(timestamp.stamp,
                    style: const TextStyle(
                        fontSize: 20.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start),
            ),
            Expanded(
              child:
              Text(timestamp.number,
                  style: const TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold),
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
