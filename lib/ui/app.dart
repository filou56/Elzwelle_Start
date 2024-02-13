import 'package:flutter/material.dart';
import 'package:elzwelle_start/ui/screens/home/home_page.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';

const String routeAdd = '/add';
const String routeHome = '/';

class SheetsApp extends StatelessWidget {
  final MqttHandler mqttHandler;

  const SheetsApp({
    required this.mqttHandler,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("START");
    return MaterialApp(
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
      title: 'Elzwelle Timestamp App',
      initialRoute: routeHome,
      routes: {
        routeHome: (_) => HomePage(mqttHandler: mqttHandler,),
      },
    );
  }
}
