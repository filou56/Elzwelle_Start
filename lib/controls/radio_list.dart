import 'dart:core';
import 'package:flutter/material.dart';
import 'package:elzwelle_start/controls/alert.dart';

class ModeRadioListSelection {
  bool login = false;
  int index  = 0;
  String id  = "";
  final List<String> selections;

  ModeRadioListSelection(this.index, this.selections, this.login,this.id);

}

class ModeRadioListMode extends StatefulWidget {
  final ModeRadioListSelection radioList;

  const ModeRadioListMode({
    Key? key,
    required this.radioList,
  }) : super(key: key);

  @override
  _ModeRadioListModeState createState() => _ModeRadioListModeState();

}

class _ModeRadioListModeState extends State<ModeRadioListMode> {

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
                  widget.radioList.index = value ?? 0;
                  // force restart from begin with new mode
                  onAlertRestart(context);
                  //Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
                });
              },
            );
          },
          itemCount: widget.radioList.selections.length,
        ),
    );
  }
}