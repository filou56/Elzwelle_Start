import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/app.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/controls/radio_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final RadioListSelection mode = RadioListSelection(0,HOME_PAGE_MODE,false);
  final MqttHandler mqttHandler = MqttHandler(mode);

  mqttHandler.connect();

  runApp(SheetsApp(
    mqttHandler: mqttHandler,
    mode: mode,
  ));
}
