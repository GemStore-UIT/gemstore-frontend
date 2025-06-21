import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class UpdateDialog extends StatefulWidget {
  final String title;
  final String id;
  final List<TableColumn> columns;
  final Map<String, TextEditingController> controllers;
  final Map<String, dynamic> selectedForeignKeys;
  final GlobalKey<FormState> formKey;
  final void Function(Map<String, dynamic>) onUpdate;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.id,
    required this.columns,
    required this.controllers,
    required this.selectedForeignKeys,
    required this.formKey,
    required this.onUpdate,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!widget.formKey.currentState!.validate()) return;

    final updatedData = <String, dynamic>{};

    for (final column in widget.columns) {
      if (column.isForeignKey && column.foreignKeyConfig != null) {
        final selectedValue = widget.selectedForeignKeys[column.key];
        if (selectedValue != null) {
          updatedData[column.key] = selectedValue;
        }
      } else {
        final controller = widget.controllers[column.key];
        if (controller != null) {
          updatedData[column.key] = controller.text;
        }
      }
    }

    widget.onUpdate(updatedData);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  Widget _buildFormField(TableColumn column) {
    if (column.isForeignKey && column.foreignKeyConfig != null) {
      return _buildForeignKeyDropdown(column);
    } else {
      return _buildTextFormField(column);
    }
  }

  Widget _buildForeignKeyDropdown(TableColumn column) {
    final config = column.foreignKeyConfig!;
    final selectedValue = widget.selectedForeignKeys[column.key];

    return DropdownButtonFormField<Map<String, dynamic>>(
      value: selectedValue,
      decoration: InputDecoration(
        labelText: column.header,
        border: const OutlineInputBorder(),
      ),
      items:
          config.options.map((option) {
            return DropdownMenuItem<Map<String, dynamic>>(
              value: option,
              child: Text(
                config.getDisplayText(option),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
      onChanged: (value) {
        setState(() {
          widget.selectedForeignKeys[column.key] = value;
        });
      },
      validator: (value) {
        if (value == null) {
          return '${column.header} is required';
        }
        return null;
      },
    );
  }

  Widget _buildTextFormField(TableColumn column) {
    return TextFormField(
      controller: widget.controllers[column.key],
      decoration: InputDecoration(
        labelText: column.header,
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '${column.header} is required';
        } else if (column.validator != null) {
          final isValid = column.validator!(value.trim());
          if (!isValid) {
            return '${column.errorMessage}';
          }
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: AlertDialog(
        title: Text("Cập nhật ${widget.title}"),
        content: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mã ${widget.title}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.lock, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            widget.id,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Mã ${widget.title} không thể thay đổi',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[500],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...widget.columns.map((column) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildFormField(column),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(onPressed: _handleUpdate, child: const Text('Update')),
        ],
      ),
    );
  }
}