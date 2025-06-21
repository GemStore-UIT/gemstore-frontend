import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class QlttCreateDialog extends StatefulWidget {
  final String title;
  final List<TableColumn> columns;
  final Function(Map<String, dynamic>) onCreate;

  const QlttCreateDialog({
    super.key,
    required this.title,
    required this.columns,
    required this.onCreate,
  });

  @override
  State<QlttCreateDialog> createState() => _QlttCreateDialogState();
}

class _QlttCreateDialogState extends State<QlttCreateDialog> {
  late Map<String, TextEditingController> _controllers;
  late Map<String, dynamic> _dropdownValues;
  late Map<String, String?> _validationErrors;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var column in widget.columns)
        if (column.editable && !(column.isForeignKey))
          column.key: TextEditingController(),
    };
    _dropdownValues = {
      for (var column in widget.columns)
        if (column.isForeignKey && column.key != 'id')
          column.key:
              (column.foreignKeyConfig?.options.isNotEmpty ?? false)
                  ? column.foreignKeyConfig!.options.first
                  : null,
    };
    _validationErrors = {
      for (var column in widget.columns)
        if (column.editable && column.key != 'id')
          column.key: null,
    };
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _validateField(TableColumn column, String? value) {
    // Kiểm tra không được trống
    if (value == null || value.trim().isEmpty) {
      return 'Trường này không được để trống';
    }

    // Kiểm tra validator tùy chỉnh nếu có
    if (column.validator != null && !column.validator!(value)) {
      return column.errorMessage ?? 'Giá trị không hợp lệ';
    }

    return null;
  }

  String? _validateDropdown(TableColumn column, dynamic value) {
    // Kiểm tra dropdown không được null
    if (value == null) {
      return 'Vui lòng chọn một giá trị';
    }
    return null;
  }

  void _validateAllFields() {
    setState(() {
      _validationErrors.clear();
      
      // Validate text fields
      for (var column in widget.columns) {
        if (column.editable && !column.isForeignKey && column.key != 'id') {
          String? value = _controllers[column.key]?.text;
          _validationErrors[column.key] = _validateField(column, value);
        }
      }

      // Validate dropdown fields
      for (var column in widget.columns) {
        if (column.editable && column.isForeignKey && column.key != 'id') {
          dynamic value = _dropdownValues[column.key];
          _validationErrors[column.key] = _validateDropdown(column, value);
        }
      }
    });
  }

  bool _hasValidationErrors() {
    return _validationErrors.values.any((error) => error != null);
  }

  void _handleCreate() {
    _validateAllFields();
    
    if (_hasValidationErrors()) {
      // Hiển thị snackbar nếu có lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng kiểm tra và sửa các lỗi trong form'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final newData = <String, dynamic>{};
    for (var column in widget.columns) {
      if (column.key == 'id') continue;
      if (column.isForeignKey) {
        newData[column.key] = _dropdownValues[column.key];
      } else {
        newData[column.key] = _controllers[column.key]?.text ?? '';
      }
    }
    widget.onCreate(newData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 400,
          maxWidth: 500,
          minHeight: 300,
          maxHeight: 600,
        ),
        child: IntrinsicHeight(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text(
                        'Thêm ${widget.title}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: widget.columns.where((column) => column.editable).map((column) {
                        if (column.isForeignKey) {
                          final options = column.foreignKeyConfig?.options ?? [];
                          final hasError = _validationErrors[column.key] != null;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DropdownButtonFormField<dynamic>(
                                  value: _dropdownValues[column.key],
                                  items: options.map<DropdownMenuItem<dynamic>>((option) {
                                    String display = option.values.elementAt(1).toString();
                                    return DropdownMenuItem(
                                      value: option,
                                      child: Text(display, overflow: TextOverflow.ellipsis),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _dropdownValues[column.key] = value;
                                      // Clear error when user selects a value
                                      _validationErrors[column.key] = null;
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: column.header,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: hasError ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: hasError ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: hasError ? Colors.red : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.arrow_drop_down,
                                      color: hasError ? Colors.red : Theme.of(context).primaryColorLight,
                                    ),
                                    filled: true,
                                    fillColor: hasError ? Colors.red[50] : Colors.grey[100],
                                  ),
                                ),
                                if (hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, left: 12),
                                    child: Text(
                                      _validationErrors[column.key]!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        } else {
                          final hasError = _validationErrors[column.key] != null;
                          
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  controller: _controllers[column.key],
                                  maxLines: 1,
                                  onChanged: (value) {
                                    // Clear error when user starts typing
                                    if (_validationErrors[column.key] != null) {
                                      setState(() {
                                        _validationErrors[column.key] = null;
                                      });
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: column.header,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: hasError ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: hasError ? Colors.red : Colors.grey,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                        color: hasError ? Colors.red : Theme.of(context).primaryColor,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.edit,
                                      color: hasError ? Colors.red : Theme.of(context).primaryColorLight,
                                    ),
                                    filled: true,
                                    fillColor: hasError ? Colors.red[50] : Colors.grey[100],
                                  ),
                                  style: const TextStyle(overflow: TextOverflow.ellipsis),
                                ),
                                if (hasError)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4, left: 12),
                                    child: Text(
                                      _validationErrors[column.key]!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.redAccent),
                        label: const Text('Hủy', style: TextStyle(color: Colors.redAccent)),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton.icon(
                        onPressed: _handleCreate,
                        icon: const Icon(Icons.check_circle_outline),
                        label: const Text('Thêm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}