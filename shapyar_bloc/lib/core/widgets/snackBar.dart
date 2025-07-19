import 'package:flutter/material.dart';

showSnack(context, String message, Color color) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style:
      const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
    backgroundColor: color,
  ));
}