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

  @override
  void initState() {
    super.initState();
    _controllers = {
      for (var column in widget.columns)
        if (column.key != 'id' && !(column.isForeignKey))
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
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _handleCreate() {
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
                    children: widget.columns.where((column) => column.key != 'id').map((column) {
                      if (column.isForeignKey) {
                        final options = column.foreignKeyConfig?.options ?? [];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: DropdownButtonFormField<dynamic>(
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
                              });
                            },
                            decoration: InputDecoration(
                              labelText: column.header,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: TextField(
                            controller: _controllers[column.key],
                            maxLines: 1,
                            decoration: InputDecoration(
                              labelText: column.header,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(
                                Icons.edit,
                                color: Theme.of(context).primaryColorLight,
                              ),
                              filled: true,
                              fillColor: Colors.grey[100],
                            ),
                            style: const TextStyle(overflow: TextOverflow.ellipsis),
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
    );
  }
}
