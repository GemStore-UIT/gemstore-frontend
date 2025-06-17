import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String title;
  final List<String> message;
  final VoidCallback? onClose;

  const ErrorDialog({
    super.key,
    this.title = 'Error',
    required this.message,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: message
            .map(
              (msg) => Text(
                "- $msg",
                style: const TextStyle(fontSize: 16),
              ),
            )
            .toList(),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
            if (onClose != null) onClose!();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
