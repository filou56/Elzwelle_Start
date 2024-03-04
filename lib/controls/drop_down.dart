import 'dart:core';
import 'package:flutter/material.dart';
// import 'dart:io' show Platform, exit;
// import 'package:flutter/services.dart';

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
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,

        children: [
            DropdownButton<String>(
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
              ),
            // MaterialButton(
            //     shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10)),
            //     height: 58,
            //     child: const Text(
            //         "Beenden",
            //         style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 22.0,
            //       ),
            //     ),
            //     color: Theme
            //         .of(context)
            //         .primaryColor,
            //     onPressed: () async {
            //         if (Platform.isAndroid) {
            //           SystemNavigator.pop();
            //         } else {
            //           exit(0);
            //         }
            //     }),
          ],
    );
  }
}