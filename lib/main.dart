import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/app.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  var conNet = 1; // default to elzwelle 192.168.1.100

  if (Platform.isAndroid) {
    print("Platform Android");
    conNet = 2;

  } else if (Platform.isLinux || Platform.isWindows ) {
    print("Platform Linux");
    print(args);
    if (args.contains("hivemq")) {
      conNet = 2;
    } else if (args.contains("elzwelle")) {
      conNet = 1;
    } else if (args.contains("local")) {
      conNet = 0;
    }
  }

  final ModeRadioListSelection mode = ModeRadioListSelection(0,HOME_PAGE_MODE,
      false,const Uuid().v1().replaceAll("-",""));

  var config = MqttConfig(net:conNet);

  final MqttHandler mqttHandler = MqttHandler(config,mode);

  mqttHandler.connect();

  print(mode.id);

  runApp(SheetsApp(
    mqttHandler: mqttHandler,
    mode: mode,
  ));
}
