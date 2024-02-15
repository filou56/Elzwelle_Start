import 'dart:core';
import 'package:flutter/material.dart';

class DropdownButtonMode extends StatefulWidget {
  const DropdownButtonMode({Key? key}) : super(key: key);

  @override
  State<DropdownButtonMode> createState() => _DropdownButtonModeState();
}

const List<String> list = <String>['Start', 'Finish'];

class _DropdownButtonModeState extends State<DropdownButtonMode> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.lightBlue),
      underline: Container(
        height: 2,
        color: Colors.lightBlueAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}