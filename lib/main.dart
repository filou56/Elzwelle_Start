import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/app.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final MqttHandler mqttHandler = MqttHandler();;

  mqttHandler.connect();

  runApp(SheetsApp(
    mqttHandler: mqttHandler,
  ));
}
