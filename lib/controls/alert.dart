import 'dart:core';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

onAlertRestart(context) {
  // Reusable alert style
  var alertStyle = AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
        side: const BorderSide(
          color: Colors.blue, //const Color(0xFF0040E0),
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.blue,
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
    type: AlertType.none,
    title: "MODUS WECHSEL",
    desc: "Alle Daten werden zurükgesetzt",
    buttons: [
      DialogButton(
        child: const Text(
          "Cancel",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.lightBlue,
        radius: BorderRadius.circular(0.0),
      ),
      DialogButton(
        child: const Text(
          "Ok",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false),
        color: Colors.green,
        radius: BorderRadius.circular(0.0),
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
        borderRadius: BorderRadius.circular(0.0),
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
          "Quit",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        onPressed: () => Navigator.pop(context),
        color: Colors.lightBlue,
        radius: BorderRadius.circular(0.0),
      ),
    ],
  ).show();
}
