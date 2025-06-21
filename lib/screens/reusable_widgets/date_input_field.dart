import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateInputFieldWithPicker extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final ValueChanged<DateTime?>? onDatePicked;
  final int soNgayGiaoToiDa;
  final DateTime current;

  const DateInputFieldWithPicker({
    super.key,
    required this.controller,
    required this.labelText,
    required this.soNgayGiaoToiDa,
    required this.current,
    this.onDatePicked,
  });

  Future<void> _pickDate(BuildContext context) async {
    // Parse ngày hiện tại trong controller, nếu không parse được thì lấy ngày current
    DateTime? initialDate;
    try {
      if (controller.text.isNotEmpty) {
        final parsedDate = DateFormat('dd/MM/yyyy').parse(controller.text);
        // Kiểm tra nếu ngày đã parse có hợp lệ không
        if (parsedDate.isBefore(current) || 
            parsedDate.difference(current).inDays > soNgayGiaoToiDa) {
          initialDate = current;
        } else {
          initialDate = parsedDate;
        }
      } else {
        initialDate = current;
      }
    } catch (_) {
      initialDate = current;
    }

    // Tính toán firstDate và lastDate dựa trên ràng buộc
    final firstDate = current;
    final lastDate = current.add(Duration(days: soNgayGiaoToiDa));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      // Thêm helper text để người dùng biết giới hạn
      helpText: 'Chọn ngày từ ${DateFormat('dd/MM/yyyy').format(firstDate)} đến ${DateFormat('dd/MM/yyyy').format(lastDate)}',
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
        // Thêm helper text để hiển thị giới hạn ngày
        helperText: 'Từ ${DateFormat('dd/MM/yyyy').format(current)} đến ${DateFormat('dd/MM/yyyy').format(current.add(Duration(days: soNgayGiaoToiDa)))}',
        helperMaxLines: 2,
      ),
      readOnly: true, // không cho gõ tay
      onTap: () => _pickDate(context),
      // Thêm validator để kiểm tra ngày nhập vào
      validator: (value) {
        if (value == null || value.isEmpty) {
          return null; // Cho phép để trống nếu không bắt buộc
        }
        
        try {
          final date = DateFormat('dd/MM/yyyy').parse(value);
          if (date.isBefore(current)) {
            return 'Ngày không được trước ${DateFormat('dd/MM/yyyy').format(current)}';
          }
          if (date.difference(current).inDays > soNgayGiaoToiDa) {
            return 'Ngày không được quá $soNgayGiaoToiDa ngày từ ${DateFormat('dd/MM/yyyy').format(current)}';
          }
          return null;
        } catch (_) {
          return 'Định dạng ngày không hợp lệ';
        }
      },
    );
  }
}