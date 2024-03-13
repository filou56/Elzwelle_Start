import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/app.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:uuid/uuid.dart';
import 'dart:io' show Platform;

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  final ModeRadioListSelection mode = ModeRadioListSelection(0,HOME_PAGE_MODE,
      false,const Uuid().v1().replaceAll("-",""));

  var config = MqttConfig(net:1);

  final MqttHandler mqttHandler = MqttHandler(config,mode);

  mqttHandler.connect();

  if (Platform.isAndroid) {
    print("Platform Android");
  } else if (Platform.isLinux) {
    print("Platform Linux");
    print(args);
  }

  print(mode.id);

  runApp(SheetsApp(
    mqttHandler: mqttHandler,
    mode: mode,
  ));
}
