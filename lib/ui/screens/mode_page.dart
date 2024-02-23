import 'package:flutter/material.dart';
import 'package:elzwelle_start/controls/radio_list.dart';
import 'package:elzwelle_start/configs/text_strings.dart';

class ModePage extends StatefulWidget {
  final RadioListSelection mode;

  const ModePage({
    Key? key,
    required this.mode
  }) : super(key: key);
  
  @override
  State<StatefulWidget> createState() {
    return ModePageState();
  }
}

class ModePageState extends State<ModePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(MODE_PAGE_TITLE),
      ),
      body: RadioListMode(radioList: widget.mode),
    );
  }
}
