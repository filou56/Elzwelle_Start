import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:flutter/services.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/mqtt_messages.dart';

class ModePage extends StatefulWidget {
  final ModeRadioListSelection mode;
  final MqttHandler        mqttHandler;

  const ModePage({
    Key? key,
    required this.mode,
    required this.mqttHandler
  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return ModePageState();
  }
}

class ModePageState extends State<ModePage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
        canPop: false,
        child: Scaffold(
            appBar: AppBar(
                title: const Text(MODE_PAGE_TITLE),
                automaticallyImplyLeading: false
            ),
            body: Container(
                child:
                ValueListenableBuilder<String>(
                  builder: (BuildContext context, String login, Widget? child) {
                    print('Notify: $login ');
                    if (login == "AKN") {
                      widget.mode.login = true;
                    }
                    if (!widget.mode.login) {
                      return Center(
                        child: SizedBox(
                          width: 300,
                          //width:  size > 300 ? 300 : size,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextFormField(
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold),
                                controller: _pinController,
                                decoration: InputDecoration(
                                    labelText: PIN_INPUT_HINT),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                // Only numbers can be entered
                              ),
                              MaterialButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 58,
                                  child: const Text(
                                    PIN_SEND,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                  color: Theme
                                      .of(context)
                                      .primaryColor,
                                  onPressed: () async {
                                    var pin = 0;
                                    try {
                                      pin = int.parse(_pinController.text)+4096;
                                      final message = pin.toRadixString(16)+widget.mode.id;
                                      widget.mqttHandler.publishMessage(
                                          MQTT_LOGIN_PUB, message);
                                    } on Exception catch (e) {
                                      // Anything else that is an exception
                                      if (kDebugMode) {
                                        print('add_page exception: $e');
                                      }
                                    } finally {
                                      final message = '$pin';
                                      if (kDebugMode) {
                                        print('Message: $message');
                                      }
                                    }
                                  }),
                            ], // children
                          ),
                        ),
                      );
                    } else {
                      return ModeRadioListMode(radioList: widget.mode);
                    }
                  },
                  valueListenable: widget.mqttHandler.login,
                )
            )
        )
    );
  }
}