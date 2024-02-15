import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/screens/home/home_page.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/configs/text_strings.dart';

const String routeAdd = '/add';
const String routeHome = '/';

class SheetsApp extends StatelessWidget {
  final MqttHandler mqttHandler;
  final RadioListSelection mode;

  const SheetsApp({
    required this.mqttHandler,
    required this.mode,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("START");
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
          brightness:   Brightness.light,
          primaryColor: Colors.blue,
          // Bug in theming, set manual
          appBarTheme: const AppBarTheme(
              color:           Colors.blue,
              foregroundColor: Colors.white
          ),
          // textTheme: const TextTheme(
          //   displayLarge: TextStyle(
          //     fontSize: 60,
          //   ),
          //   displayMedium: TextStyle(
          //     fontSize: 40,
          //   ),
          //   displaySmall: TextStyle(
          //     fontSize: 20,
          //   ),
          // ),
      ),
      title: APP_TITLE,
      initialRoute: routeHome,
      routes: {
        routeHome: (_) => HomePage(mqttHandler: mqttHandler, mode: mode),
      },
    );
  }
}
