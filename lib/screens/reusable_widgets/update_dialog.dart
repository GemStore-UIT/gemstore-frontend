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
  final List<Map<String, dynamic>>? details;
  final List<Map<String, dynamic>>? options;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.id,
    required this.columns,
    required this.controllers,
    required this.selectedForeignKeys,
    required this.formKey,
    required this.onUpdate,
    this.details,
    this.options,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  List<Map<String, dynamic>> _detailsData = [];

  @override
  void initState() {
    super.initState();
    if (widget.details != null) {
      _detailsData = List.from(widget.details!);
    }
  }

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

    // Include details data if available
    if (widget.details != null) {
      updatedData['details'] = _detailsData;
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
      items: config.options.map((option) {
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

  Widget _buildDetailsTable() {
    if (widget.details == null || widget.details!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Get column headers from the first detail item
    final headers = widget.details!.first.keys.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Divider(),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chi tiết',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (widget.options != null && widget.options!.isNotEmpty)
              ElevatedButton.icon(
                onPressed: _addDetailRow,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Thêm'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(80, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              // Table Header
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    ...headers.map((header) => Expanded(
                      child: Text(
                        header,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    )),
                    const SizedBox(width: 60), // Space for action buttons
                  ],
                ),
              ),
              // Table Rows
              ..._detailsData.asMap().entries.map((entry) {
                final index = entry.key;
                final detail = entry.value;
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      ...headers.map((header) => Expanded(
                        child: Text(
                          detail[header]?.toString() ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 13),
                        ),
                      )),
                      SizedBox(
                        width: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => _editDetailRow(index),
                              icon: const Icon(Icons.edit, size: 16),
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                            IconButton(
                              onPressed: () => _deleteDetailRow(index),
                              icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                              constraints: const BoxConstraints(
                                minWidth: 24,
                                minHeight: 24,
                              ),
                              padding: const EdgeInsets.all(4),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (_detailsData.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Không có dữ liệu chi tiết',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _addDetailRow() {
    if (widget.options == null || widget.options!.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => _DetailRowDialog(
        options: widget.options!,
        onSave: (newDetail) {
          setState(() {
            _detailsData.add(newDetail);
          });
        },
      ),
    );
  }

  void _editDetailRow(int index) {
    if (widget.options == null || widget.options!.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => _DetailRowDialog(
        options: widget.options!,
        initialData: _detailsData[index],
        onSave: (updatedDetail) {
          setState(() {
            _detailsData[index] = updatedDetail;
          });
        },
      ),
    );
  }

  void _deleteDetailRow(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa dòng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _detailsData.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: AlertDialog(
        title: Text("Cập nhật ${widget.title}"),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
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
                  _buildDetailsTable(),
                ],
              ),
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

class _DetailRowDialog extends StatefulWidget {
  final List<Map<String, dynamic>> options;
  final Map<String, dynamic>? initialData;
  final Function(Map<String, dynamic>) onSave;

  const _DetailRowDialog({
    required this.options,
    this.initialData,
    required this.onSave,
  });

  @override
  State<_DetailRowDialog> createState() => _DetailRowDialogState();
}

class _DetailRowDialogState extends State<_DetailRowDialog> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {};
  final Map<String, dynamic> _selectedValues = {};

  @override
  void initState() {
    super.initState();
    
    // Initialize controllers and selected values based on options structure
    if (widget.options.isNotEmpty) {
      final firstOption = widget.options.first;
      for (String key in firstOption.keys) {
        _controllers[key] = TextEditingController(
          text: widget.initialData?[key]?.toString() ?? '',
        );
        _selectedValues[key] = widget.initialData?[key];
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) return;

    final result = <String, dynamic>{};
    for (String key in _controllers.keys) {
      result[key] = _selectedValues[key] ?? _controllers[key]!.text;
    }

    widget.onSave(result);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.options.isEmpty) {
      return AlertDialog(
        title: const Text('Lỗi'),
        content: const Text('Không có tùy chọn để hiển thị'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      );
    }

    final fields = widget.options.first.keys.toList();

    return AlertDialog(
      title: Text(widget.initialData == null ? 'Thêm chi tiết' : 'Sửa chi tiết'),
      content: SizedBox(
        width: 400,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fields.map((field) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: TextFormField(
                  controller: _controllers[field],
                  decoration: InputDecoration(
                    labelText: field,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return '$field is required';
                    }
                    return null;
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: const Text('Lưu'),
        ),
      ],
    );
  }
}