import 'package:flutter/material.dart';
import 'package:gemstore_frontend/config/format.dart';

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
  static Widget formatMoney(int amount, Color color) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Format.moneyFormat(amount),
          style: TextStyle(fontSize: 14, color: color),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget formatDate(String date) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Format.dateFormat(date),
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget formatPercentage(String value) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Format.percentageFormat(value),
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  static Widget formatStatus(String status) {
    return SizedBox(
      height: 40,
      child: Align(
        alignment: Alignment.centerLeft,
        child: status == "Hoàn thành"
        ? const Icon(Icons.check_circle, color: Colors.green, size: 20)
        : const Icon(Icons.cancel, color: Colors.red, size: 20),
      ),
    );
  }
}