import 'package:flutter/material.dart';

InputDecoration textFieldDecoration({required String hint}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    labelText: hint,
    labelStyle: const TextStyle(color: Color(0xffd2d2d7)),
    floatingLabelStyle: const TextStyle(
      color: Colors.blue,
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: Color(0xffd2d2d7),
      ),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(
        width: 4,
        color: Colors.blue,
      ),
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
  );
}
