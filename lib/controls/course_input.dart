import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/configs/mqtt_messages.dart';
import 'package:elzwelle_start/controls/alert.dart';

List<DropdownMenuItem<String>> get dropdownItems{
  List<DropdownMenuItem<String>> menuItems = [
    DropdownMenuItem(child: Text(COURSE_SELECTION_TEXT[0]),value: "0"),
    DropdownMenuItem(child: Text(COURSE_SELECTION_TEXT[1]),value: "1"),
    DropdownMenuItem(child: Text(COURSE_SELECTION_TEXT[2]),value: "2"),
    DropdownMenuItem(child: Text(COURSE_SELECTION_TEXT[3]),value: "3"),
    DropdownMenuItem(child: Text(COURSE_SELECTION_TEXT[4]),value: "4"),
  ];
  return menuItems;
}

// ignore: must_be_immutable
class CourseInput extends StatefulWidget {
    final MqttHandler mqttHandler;
    String selectedValue = "0";

CourseInput({
    required this.mqttHandler,
    Key? key,
    }) : super(key: key);
    @override
    _CourseInputState createState() => _CourseInputState();
}

class _CourseInputState extends State<CourseInput> {
  final TextEditingController _numController      = TextEditingController();
  final TextEditingController _gateController     = TextEditingController();
  final TextEditingController _remarkController   = TextEditingController();

  @override
  void dispose() {
    _gateController.dispose();
    _numController.dispose();
    _remarkController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;
    TextStyle _textStyle = TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold,
                              color: Colors.black,
                            );
    String status = "";

    return Scaffold(
      body: ValueListenableBuilder<String>(
        builder: (BuildContext context, String akn, Widget? child) {
          print('Notify course: $akn');

          if (akn == "SEND") {
            status = COURSE_STATUS_SEND;
            _textStyle = const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold,
              color: Colors.cyan,
            );
          } else if (akn == "OK") {
            status = COURSE_STATUS_OK;
            _textStyle = const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold,
              color: Colors.green,
            );
          } else {
            status = '';
            _textStyle = const TextStyle(
              fontSize: 20.0, fontWeight: FontWeight.bold,
              color: Colors.black,
            );
          }
          widget.mqttHandler.akn.value = '';

          return Center(
            child: SizedBox(
              width:  size > 300 ? 300 : size,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text( status,
                      style: _textStyle,
                      textAlign: TextAlign.start),
                  TextFormField(
                    style: _textStyle,
                    controller: _numController,
                    decoration: InputDecoration(labelText: COURSE_INP_HINT[0]),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    onChanged: (_) => setState(() {}),
                  ),
                  TextFormField(
                    style: _textStyle,
                    controller: _gateController,
                    decoration: InputDecoration(labelText: COURSE_INP_HINT[1]),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ], // Only numbers can be entered
                    onChanged: (_) => setState(() {}),
                  ),
                  TextFormField(
                    style: _textStyle,
                    controller: _remarkController,
                    decoration: const InputDecoration(labelText: REMARK_HINT),
                    onChanged: (_) => setState(() {}),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9a-zA-Z]")),
                    ], // Only numbers can be entered
                  ),
                  DropdownButton(
                      value: widget.selectedValue,
                      onChanged: (String? newValue){
                        setState(() {
                          widget.selectedValue = newValue!;
                        });
                      },
                      items: dropdownItems
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    height: 58,
                    child: const Text(
                      COURSE_SEND,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                      ),
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () async {
                      var num     = 0;
                      var gate    = 0;
                      var errno   = 0;
                      var remark  = '';
                      var id      = widget.mqttHandler.mode.id;
                      try {
                        num     = int.parse(_numController.text);
                        gate    = int.parse(_gateController.text);
                        errno   = int.parse(widget.selectedValue);
                        remark  = _remarkController.text; //.replaceAll(' ', '_');
                        final message = '$num,$gate,${COURSE_PENALTY_SECONDS[errno]},${COURSE_SELECTION_TEXT[errno]} $remark,$id';
                        widget.mqttHandler.publishMessage(MQTT_COURSE_DATA_PUB, message);
                      } on Exception catch (e) {
                        onAlertError(context,INPUT_ERROR_TEXT,INPUT_ERROR_INFO);
                        // Anything else that is an exception
                        if (kDebugMode) {
                          print('add_page exception: $e');
                        }
                      } finally {
                        final message = '$num,$gate,${COURSE_PENALTY_SECONDS[errno]},${COURSE_SELECTION_TEXT[errno]} $remark,$id';
                        if (kDebugMode) {
                          print('Message: $message');
                        }
                      }
                    }),
                ], // children
              ),
            ),
            );
        },
        valueListenable: widget.mqttHandler.akn,
      )
    );
  }
}