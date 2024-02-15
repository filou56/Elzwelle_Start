import 'dart:core';
import 'package:flutter/material.dart';

class RadioListValue {
  int index = 1;
}

class RadioListMode extends StatefulWidget {
  RadioListValue value;

  RadioListMode({
    Key? key,
    required this.value,
  }) : super(key: key);

  @override
  _RadioListModeState createState() => _RadioListModeState();
}

class _RadioListModeState extends State<RadioListMode> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: double.maxFinite,
        height: 200,
        child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              // Create a RadioListTile for option 1
              RadioListTile(
                fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                title: const Text('Start'),                       // Display the title for option 1
                //subtitle: const Text('Subtitle for Option 1'),  // Display a subtitle for option 1
                value: 1,                                         // Assign a value of 1 to this option
                groupValue: widget.value.index,                   // Use _selectedValue to track the selected option
                onChanged: (value) {
                  setState(() {
                    widget.value.index = value! as int; // Update _selectedValue when option 1 is selected
                    Navigator.popAndPushNamed(context,'/');
                  });
                },
              ),

              // Create a RadioListTile for option 2
              RadioListTile(
                fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                title: const Text('Finish'),                      // Display the title for option 2
                //subtitle: const Text('Subtitle for Option 2'),  // Display a subtitle for option 2
                value: 2,                                         // Assign a value of 2 to this option
                groupValue: widget.value.index,                   // Use _selectedValue to track the selected option
                onChanged: (value) {
                  setState(() {
                    widget.value.index = value! as int; // Update _selectedValue when option 2 is selected
                    Navigator.popAndPushNamed(context,'/');
                  });
                },
              ),
            ]
        )
    );
  }
}