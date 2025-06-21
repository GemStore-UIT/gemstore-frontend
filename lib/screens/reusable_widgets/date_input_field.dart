import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class DateInputFieldWithPicker extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueChanged<DateTime?>? onDatePicked;

  const DateInputFieldWithPicker({
    Key? key,
    required this.controller,
    required this.labelText,
    this.onDatePicked,
  }) : super(key: key);

  Future<void> _pickDate(BuildContext context) async {
    // Parse ngày hiện tại trong controller, nếu không parse được thì lấy ngày hôm nay
    DateTime? initialDate;
    try {
      initialDate = controller.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(controller.text)
          : DateTime.now();
    } catch (_) {
      initialDate = DateTime.now();
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
      onDatePicked?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () => _pickDate(context),
        ),
      ),
      readOnly: true, // không cho gõ tay
      onTap: () => _pickDate(context),
    );
  }
}

