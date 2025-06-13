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
  final List<TableColumn> columns;
  final Map<String, TextEditingController> controllers;
  final GlobalKey<FormState> formKey;
  final Future<void> Function(Map<String, dynamic>) onUpdate;

  const UpdateDialog({
    super.key,
    required this.title,
    required this.columns,
    required this.controllers,
    required this.formKey,
    required this.onUpdate,
  });

  @override
  State<UpdateDialog> createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    if (!widget.formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final updatedData = <String, dynamic>{};
      for (final entry in widget.controllers.entries) {
        updatedData[entry.key] = entry.value.text;
      }

      await widget.onUpdate(updatedData);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error updating data: $error')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_isLoading,
      child: AlertDialog(
        title: Text(widget.title),
        content: SingleChildScrollView(
          child: Form(
            key: widget.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...widget.columns.map((column) {
                  final controller = widget.controllers[column.key]!;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        labelText: column.header,
                        border: const OutlineInputBorder(),
                        enabled: !_isLoading,
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
            onPressed:
                _isLoading
                    ? null
                    : () {
                      if (mounted) {
                        Navigator.of(context).pop();
                      }
                    },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _handleUpdate,
            child:
                _isLoading
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : const Text('Update'),
          ),
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
  final Function(String id, Map<String, dynamic> updatedData)? onUpdate;
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
            title: 'Cập nhật ${widget.title}',
            columns: widget.columns.where((col) => col.editable).toList(),
            controllers: controllers,
            formKey: formKey,
            onUpdate: (updatedData) async {
              if (widget.onUpdate != null) {
                await widget.onUpdate!(rowData.id, updatedData);
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
            title: const Text('Confirm Delete'),
            content: const Text('Are you sure you want to delete this item?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  if (widget.onDelete != null && mounted) {
                    widget.onDelete!(id);
                  }
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Delete'),
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
                                              rowData.data[column.key],
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
