import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/configs/mqtt_messages.dart';

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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    return Scaffold(
    body: Center(
      child: SizedBox(
        width:  size > 300 ? 300 : size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              style: const TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold),
              controller: _numController,
              decoration: InputDecoration(labelText: COURSE_INP_HINT[0]),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (_) => setState(() {}),
            ),
            TextFormField(
              style: const TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold),
              controller: _gateController,
              decoration: InputDecoration(labelText: COURSE_INP_HINT[1]),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ], // Only numbers can be entered
              onChanged: (_) => setState(() {}),
            ),
            TextFormField(
              style: const TextStyle(
                  fontSize: 24.0, fontWeight: FontWeight.bold),
              controller: _remarkController,
              decoration: const InputDecoration(labelText: REMARK_HINT),
              onChanged: (_) => setState(() {}),
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
              height: 58,
              child: Text(
                COURSE_SEND,
                style: const TextStyle(
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
                try {
                  num     = int.parse(_numController.text);
                  gate    = int.parse(_gateController.text);
                  errno   = int.parse(widget.selectedValue);
                  remark  = _remarkController.text; //.replaceAll(' ', '_');
                  final message = '$num,$gate,${COURSE_PENALTY_SECONDS[errno]},${COURSE_SELECTION_TEXT[errno]} $remark';
                  widget.mqttHandler.publishMessage(MQTT_COURSE_DATA_PUB, message);
                } on Exception catch (e) {
                  // Anything else that is an exception
                  print('add_page exception: $e');
                } finally {
                  final message = '$num,$gate,${COURSE_PENALTY_SECONDS[errno]},${COURSE_SELECTION_TEXT[errno]} $remark';
                  print('Message: $message');
                }
              }),
          ], // children
        ),
      ),
      ),
    );
  }
}