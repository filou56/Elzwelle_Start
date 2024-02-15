import 'dart:core';
import 'package:flutter/material.dart';

class RadioListSelection {
  int index;
  final List<String> selections;

  RadioListSelection(this.index, this.selections);
}

class RadioListMode extends StatefulWidget {
  final RadioListSelection radioList;

  const RadioListMode({
    Key? key,
    required this.radioList,
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
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return RadioListTile<int>(
              fillColor: MaterialStateColor.resolveWith((states) => Colors.blue),
              value: index,
              groupValue: widget.radioList.index,
              toggleable: true,
              title: Text(widget.radioList.selections[index]),
              onChanged: (int? value) {
                setState(() {
                  widget.radioList.index = value!;
                  // force restart from begin with new mode
                  Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                });
              },
            );
          },
          itemCount: widget.radioList.selections.length,
        ),
    );
  }
}