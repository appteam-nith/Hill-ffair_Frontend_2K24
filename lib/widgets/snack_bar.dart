import 'package:flutter/material.dart';

showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // background color
      backgroundColor: const Color.fromARGB(255, 201, 231, 255),
      content: Text(
        text,
        style: const TextStyle(fontFamily: "georgia", color: Colors.black),
      )));
}
