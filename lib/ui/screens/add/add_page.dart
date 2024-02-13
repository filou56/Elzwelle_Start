import 'package:format/format.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/timestamp_entity.dart';
import '../../../providers/mqtt/mqtt_handler.dart';

// List<DropdownMenuItem<String>> get dropdownItems{
//   List<DropdownMenuItem<String>> menuItems = [
//     const DropdownMenuItem(child: Text("USA"),value: "USA"),
//     const DropdownMenuItem(child: Text("Canada"),value: "Canada"),
//     const DropdownMenuItem(child: Text("Brazil"),value: "Brazil"),
//     const DropdownMenuItem(child: Text("England"),value: "England"),
//   ];
//   return menuItems;
// }

class AddPage extends StatefulWidget {
  final MqttHandler       mqttHandler;
  final TimestampEntity   timestamp;

  const AddPage({
    required this.timestamp,
    required this.mqttHandler,
    Key? key,
  }) : super(key: key);

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _timeController  = TextEditingController();
  final TextEditingController _stampController = TextEditingController();
  final TextEditingController _numController   = TextEditingController();
  //String selectedValue = "USA";

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width;

    _timeController.text  = widget.timestamp.time;
    _stampController.text = widget.timestamp.stamp;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Startnummer"),
      ),
      body: Center(
        child: SizedBox(
          width: size > 300 ? 300 : size,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /*
              DropdownButton(
                  value: selectedValue,
                  onChanged: (String? newValue){
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
                  items: dropdownItems
              ),
              */
              TextFormField(
                style: const TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.bold),
                controller: _timeController,
                onChanged: (_) => setState(() {}),
              ),
              TextFormField(
                style: const TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.bold),
                controller: _stampController,
                onChanged: (_) => setState(() {}),
              ),
              TextField(
                style: const TextStyle(
                    fontSize: 30.0, fontWeight: FontWeight.bold),
                controller: _numController,
                decoration: new InputDecoration(labelText: "Startnummer eingeben"),
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
                  child: const Text(
                    'Startnummer senden',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.0,
                    ),
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    var num = int.parse(_numController.text);
                    widget.timestamp.number = '{:d}'.format(num); // removed '#'+_numController.text;
                    final message = '${widget.timestamp.time} ${widget.timestamp.stamp} ${widget.timestamp.number}';
                    widget.mqttHandler.publishMessage('elzwelle/stopwatch/start/number',message);
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
