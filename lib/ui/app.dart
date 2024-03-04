import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/screens/home_page.dart';
import 'package:elzwelle_start/ui/screens/mode_page.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/configs/text_strings.dart';

const String routeAdd   = '/add';
const String initHome   ='/init';
const String routeHome  = '/';

class SheetsApp extends StatelessWidget {
  final MqttHandler mqttHandler;
  final ModeRadioListSelection mode;

  const SheetsApp({
    required this.mqttHandler,
    required this.mode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          brightness:   Brightness.light,
          primaryColor: Colors.lightBlue,
          // Bug in themeing, set manual
          appBarTheme: const AppBarTheme(
              color:           Colors.lightBlue,
              foregroundColor: Colors.white
          ),
      ),
      title: APP_TITLE,
      initialRoute: initHome,
      routes: {
        initHome:  (_)  => ModePage(mqttHandler: mqttHandler, mode: mode),
        routeHome: (_)  => HomePage(mqttHandler: mqttHandler, mode: mode),
      },
    );
  }
}
