import 'package:flutter/material.dart';

class FormatColumnData {
  static Widget formatId (String value) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  } 
}