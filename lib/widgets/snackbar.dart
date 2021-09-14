import 'package:flutter/material.dart';

showSnackbar(msg, context) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Colors.white,
    duration: Duration(seconds: 2),
    content: Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.red),
    ),
  ));
}
