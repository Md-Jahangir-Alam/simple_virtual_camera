import 'package:flutter/material.dart';

Widget text_button(String name, onpressed) {
  return TextButton(
      onPressed: onpressed,
      child: Text(
        name,
        style: TextStyle(fontSize: 20, color: Colors.indigoAccent),
      ));
}
