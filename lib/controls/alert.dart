import 'dart:core';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:elzwelle_start/configs/text_strings.dart';

onAlertRestart(context) {
  // Reusable alert style
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.blue, //const Color(0xFF0040E0),
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.blue,
      ),
      // MediaQuery.of(context).size.width * 0.9 // 90%
      constraints: BoxConstraints.expand(width: MediaQuery.of(context).size.width * 0.9),
      //First to chars "55" represents transparency of color
      overlayColor: const Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.topCenter);

  // Alert dialog using custom alert style
  Alert(
    context: context,
    style: alertStyle,
    type: AlertType.none,
    title: MODE_PAGE_ALERT_TEXT,
    desc: MODE_PAGE_ALERT_INFO,
    buttons: [
      DialogButton(
        child: const Text(
          ALERT_CANCEL,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.lightBlue,
        radius: BorderRadius.circular(10.0),
      ),
      DialogButton(
        child: const Text(
          ALERT_OK,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
        color: Colors.green,
        radius: BorderRadius.circular(10.0),
      ),
    ],
  ).show();
}

onAlertError(context, String err, String msg) {
  // Reusable alert style
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.blue, //const Color(0xFF0040E0),
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
      ),
      constraints: const BoxConstraints.expand(width: 300),
      //First to chars "55" represents transparency of color
      overlayColor: const Color(0x55000000),
      alertElevation: 0,
      alertAlignment: Alignment.topCenter);

  // Alert dialog using custom alert style
  Alert(
    context: context,
    style: alertStyle,
    type: AlertType.error,
    title: err,
    desc: msg,
    buttons: [
      DialogButton(
        child: const Text(
          ALERT_CONTINUE,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.lightBlue,
        radius: BorderRadius.circular(10.0),
      ),
    ],
  ).show();
}
