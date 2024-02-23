import 'package:flutter/foundation.dart';
import 'package:format/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:elzwelle_start/controls/alert.dart';
import 'package:elzwelle_start/models/timestamp_entity.dart';
import 'package:elzwelle_start/providers/mqtt/mqtt_handler.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/configs/text_strings.dart';
import 'package:elzwelle_start/configs/mqtt_messages.dart';

class AddPage extends StatefulWidget {
  final MqttHandler        mqttHandler;
  final TimestampEntity    timestamp;
  final RadioListSelection mode;

  const AddPage({
    required this.timestamp,
    required this.mqttHandler,
    required this.mode,
    Key? key,
  }) : super(key: key);
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _timeController     = TextEditingController();
  final TextEditingController _stampController    = TextEditingController();
  final TextEditingController _numController      = TextEditingController();
  final TextEditingController _remarkController   = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    _timeController.text  = widget.timestamp.time;
    _stampController.text = widget.timestamp.stamp;

    return Scaffold(
      appBar: AppBar(
        title: Text(ADD_PAGE_TITLE[widget.mode.index]),
      ),
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
                controller: _timeController,
                onChanged: (_) => setState(() {}),
              ),
              TextFormField(
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
                controller: _stampController,
                onChanged: (_) => setState(() {}),
              ),
              TextFormField(
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
                controller: _remarkController,
                decoration: const InputDecoration(labelText: REMARK_HINT),
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                style: const TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
                controller: _numController,
                decoration: InputDecoration(labelText: ADD_PAGE_HINT[widget.mode.index]),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ], // Only numbers can be entered
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(
                height: 12.0,
              ),
              MaterialButton(
                  height: 58,
                  child: Text(
                    ADD_PAGE_SEND[widget.mode.index],
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    var err = true;
                    try {
                      var num = int.parse(_numController.text);
                      widget.timestamp.tag = '?';
                      widget.timestamp.number = '{:d}'.format(
                      num); // removed '#'+_numController.text;
                      var remark = _remarkController.text.replaceAll(' ', '_');
                      final message = '${widget.timestamp.time} ${widget
                          .timestamp.stamp} ${widget.timestamp.number} $remark';
                      widget.mqttHandler.publishMessage(
                      MQTT_STAMP_NUM_PUB[widget.mode.index], message);
                      err = false;
                      } on Exception catch (e) {
                        // Anything else that is an exception
                        onAlertError(context,"Eingabe Fehler","Ein Parameter wurde nicht korrekt gesetzt!");
                        if (kDebugMode) {
                          print('add_page exception: $e');
                        }
                    } finally {
                      if ( ! err ) {
                        Navigator.pop(context);
                      }
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
