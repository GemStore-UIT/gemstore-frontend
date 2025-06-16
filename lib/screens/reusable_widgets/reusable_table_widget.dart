import 'package:flutter/material.dart';

// Data model for table rows
class TableRowData {
  final String id;
  final Map<String, dynamic> data;

  TableRowData({required this.id, required this.data});
}

// Update Dialog Widget
class UpdateDialog extends StatefulWidget {
  final String title;
  final String id;
  final List<TableColumn> columns;
  final Map<String, TextEditingController> controllers;
  final GlobalKey<FormState> formKey;
  final void Function(Map<String, dynamic>) onUpdate;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.id,
    required this.columns,
    required this.controllers,
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
    for (final entry in widget.controllers.entries) {
      updatedData[entry.key] = entry.value.text;
    }
    widget.onUpdate(updatedData);
    if (mounted) {
      Navigator.of(context).pop();
    }
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
                  padding: EdgeInsets.all(12),
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
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.lock, size: 16, color: Colors.grey[600]),
                          SizedBox(width: 8),
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
                      SizedBox(height: 4),
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
                SizedBox(height: 16),            
                ...widget.columns.map((column) {
                  final controller = widget.controllers[column.key]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: controller,
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
                    ),
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

// Column configuration
class TableColumn {
  final String key;
  final String header;
  final double? width;
  final bool editable;
  final Widget Function(dynamic value)? customWidget;
  final bool Function(String value)? validator;
  final String? errorMessage;

  TableColumn({
    required this.key,
    required this.header,
    this.width,
    this.editable = true,
    this.customWidget,
    this.validator,
    this.errorMessage,
  });
}

// Main reusable table widget
class ReusableTableWidget extends StatefulWidget {
  final String title;
  final List<TableRowData> data;
  final List<TableColumn> columns;
  final Function(TableRowData updatedData)? onUpdate;
  final Function(String id)? onDelete;
  final double? height;
  final EdgeInsets? padding;
  final bool showActions;

  const ReusableTableWidget({
    super.key,
    required this.title,
    required this.data,
    required this.columns,
    required this.onUpdate,
    this.onDelete,
    this.height = 400,
    this.padding = const EdgeInsets.all(16),
    this.showActions = true,
  });

  @override
  State<ReusableTableWidget> createState() => _ReusableTableWidgetState();
}

class _ReusableTableWidgetState extends State<ReusableTableWidget> {
  void _showUpdateDialog(TableRowData rowData) {
    final formKey = GlobalKey<FormState>();
    final controllers = <String, TextEditingController>{};

    // Initialize controllers with current data
    for (final column in widget.columns) {
      if (column.editable) {
        controllers[column.key] = TextEditingController(
          text: rowData.data[column.key]?.toString() ?? '',
        );
      }
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => UpdateDialog(
            title: widget.title,
            id: rowData.id,
            columns: widget.columns.where((col) => col.editable).toList(),
            controllers: controllers,
            formKey: formKey,
            onUpdate: (updatedData) {
              if (widget.onUpdate != null) {
                widget.onUpdate!(rowData);
              }
            },
          ),
    ).whenComplete(() {
      // Always dispose controllers when dialog is completely closed
      Future.microtask(() {
        for (final controller in controllers.values) {
          controller.dispose();
        }
      });
    });
  }

  void _deleteRow(String id) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: const Text('Bạn có chắc chắn muốn xóa mục này không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (widget.onDelete != null && mounted) {
                    widget.onDelete!(id);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );
  }

  Widget _buildCell(TableColumn column, dynamic value, bool isEditing) {
    if (column.customWidget != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: column.customWidget!(value),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 40,
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            value?.toString() ?? '',
            style: const TextStyle(fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: widget.height,
          padding: widget.padding,
          child: Column(
            children: [
              // Header
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      ...widget.columns.map(
                        (column) => Expanded(
                          flex: column.width?.toInt() ?? 1,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              column.header,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (widget.showActions)
                        SizedBox(
                          width: 120,
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            child: const Text(
                              'Actions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              // Scrollable content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child:
                      widget.data.isEmpty
                          ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text(
                                'No data available',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          )
                          : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: widget.data.length,
                            itemBuilder: (context, index) {
                              final rowData = widget.data[index];

                              return IntrinsicHeight(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        index.isEven
                                            ? Colors.white
                                            : Colors.grey[50],
                                    border: Border(
                                      bottom: BorderSide(
                                        color: Colors.grey[200]!,
                                        width: 0.5,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      ...widget.columns.map(
                                        (column) => Expanded(
                                          flex: column.width?.toInt() ?? 1,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: _buildCell(
                                              column,
                                              widget.columns.indexOf(column) ==
                                                      0
                                                  ? rowData.id
                                                  : rowData.data[column.key],
                                              false,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (widget.showActions)
                                        SizedBox(
                                          width: 120,
                                          child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(4.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap:
                                                        () => _showUpdateDialog(
                                                          rowData,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.blue,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 4),
                                                Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap:
                                                        () => _deleteRow(
                                                          rowData.id,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                    child: const Padding(
                                                      padding: EdgeInsets.all(
                                                        8.0,
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
