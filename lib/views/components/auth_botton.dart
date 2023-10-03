import 'package:flutter/material.dart';

Widget customButton({required String name, required VoidCallback onPressed}) {
  return MaterialButton(
    onPressed: onPressed,
    color: Colors.blue,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    minWidth: 300,
    height: 46,
    child:
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 16)),
  );
}

Widget bottomButtonText(
    {required String type, required VoidCallback onPressed}) {
  return InkWell(
    onTap: onPressed,
    child: Text(
      type,
      style: const TextStyle(color: Colors.blue, fontSize: 12),
    ),
  );
}
