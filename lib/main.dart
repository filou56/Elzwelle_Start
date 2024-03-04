import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/app.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final ModeRadioListSelection mode = ModeRadioListSelection(0,HOME_PAGE_MODE,
      false,const Uuid().v1().replaceAll("-",""));

  final MqttHandler mqttHandler = MqttHandler(mode);

  mqttHandler.connect();

  print(mode.id);

  runApp(SheetsApp(
    mqttHandler: mqttHandler,
    mode: mode,
  ));
}
