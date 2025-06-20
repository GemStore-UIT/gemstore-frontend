import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuaban_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/update_dialog.dart';

// Data model for table rows
class TableRowData {
  final String id;
  final Map<String, dynamic> data;

  TableRowData({required this.id, required this.data});
}

// Foreign key configuration
class ForeignKeyConfig {
  final List<Map<String, dynamic>> options;
  final String valueKey;
  final String displayKey;
  final String? displayFormat; // Optional format string with placeholders

  ForeignKeyConfig({
    required this.options,
    required this.valueKey,
    required this.displayKey,
    this.displayFormat,
  });

  String getDisplayText(Map<String, dynamic> option) {
    if (displayFormat != null) {
      String result = displayFormat!;
      option.forEach((key, value) {
        result = result.replaceAll('{$key}', value?.toString() ?? '');
      });
      return result;
    }
    return option[displayKey]?.toString() ?? '';
  }
}

// Column configuration with enhanced foreign key support
class TableColumn {
  final String key;
  final String header;
  final double? width;
  final bool editable;
  final Widget Function(dynamic value)? customWidget;
  final bool Function(String value)? validator;
  final String? errorMessage;
  final bool isForeignKey;
  final ForeignKeyConfig? foreignKeyConfig;
  final String? nestedPath; // For nested data like "loaiSanPham.tenLSP"

  TableColumn({
    required this.key,
    required this.header,
    this.width,
    this.editable = true,
    this.customWidget,
    this.validator,
    this.errorMessage,
    this.isForeignKey = false,
    this.foreignKeyConfig,
    this.nestedPath,
  });
}

// Update Dialog Widget with foreign key support
// Main reusable table widget with enhanced foreign key support
class ReusableTableWidget extends StatefulWidget {
  final String title;
  final List<TableRowData> data;
  final List<TableColumn> columns;
  final Function(TableRowData updatedData, Map<String, dynamic> newData)?
  onUpdate;
  final Function(String id)? onDelete;
  final double? height;
  final EdgeInsets? padding;
  final bool showActions;
  final bool haveDetails;
  final void Function(TableRowData rowData)? showComplexUpdateDialog;

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
    this.haveDetails = false,
    this.showComplexUpdateDialog,
  });

  @override
  State<ReusableTableWidget> createState() => _ReusableTableWidgetState();
}

class _ReusableTableWidgetState extends State<ReusableTableWidget> {
  // Helper function to get nested value from object
  dynamic _getNestedValue(Map<String, dynamic> data, String path) {
    final keys = path.split('.');
    dynamic current = data;

    for (final key in keys) {
      if (current is Map<String, dynamic> && current.containsKey(key)) {
        current = current[key];
      } else {
        return null;
      }
    }

    return current;
  }

  void _showUpdateDialog(TableRowData rowData) {
    if (!widget.haveDetails) {
      final formKey = GlobalKey<FormState>();
      final controllers = <String, TextEditingController>{};
      final selectedForeignKeys = <String, dynamic>{};

      // Initialize controllers and foreign key selections
      for (final column in widget.columns) {
        if (column.editable) {
          if (column.isForeignKey && column.foreignKeyConfig != null) {
            // Find the current selected foreign key object
            dynamic currentValue;
            if (column.nestedPath != null) {
              currentValue = _getNestedValue(rowData.data, column.nestedPath!);
            } else {
              currentValue = rowData.data[column.key];
            }

            if (currentValue != null) {
              // Find matching option in foreign key config
              final matchingOption = column.foreignKeyConfig!.options
                  .firstWhere(
                    (option) =>
                        option[column.foreignKeyConfig!.displayKey] ==
                        currentValue,
                    orElse: () => column.foreignKeyConfig!.options.first,
                  );
              selectedForeignKeys[column.key] = matchingOption;
            }
          } else {
            // Regular text field
            String currentValue = '';
            if (column.nestedPath != null) {
              final nestedValue = _getNestedValue(
                rowData.data,
                column.nestedPath!,
              );
              currentValue = nestedValue?.toString() ?? '';
            } else {
              currentValue = rowData.data[column.key]?.toString() ?? '';
            }

            controllers[column.key] = TextEditingController(text: currentValue);
          }
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
              selectedForeignKeys: selectedForeignKeys,
              formKey: formKey,
              onUpdate: (updatedData) {
                if (widget.onUpdate != null) {
                  widget.onUpdate!(rowData, updatedData);
                }
              },
            ),
      ).then((_) {
        // Đảm bảo chỉ dispose sau khi dialog đã bị huỷ hoàn toàn
        WidgetsBinding.instance.addPostFrameCallback((_) {
          for (final controller in controllers.values) {
            controller.dispose();
          }
        });
      });
    } else {
      widget.showComplexUpdateDialog!(rowData);
    }
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

  Widget _buildCell(TableColumn column, TableRowData rowData, bool isEditing) {
    dynamic value;

    if (column.key == 'id') {
      value = rowData.id;
    } else if (column.nestedPath != null) {
      value = _getNestedValue(rowData.data, column.nestedPath!);
    } else {
      value = rowData.data[column.key];
    }

    if (column.customWidget != null) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: column.customWidget!(value),
      );
    }

    // Handle foreign key display
    if (column.isForeignKey &&
        column.foreignKeyConfig != null &&
        value is Map<String, dynamic>) {
      final displayText = column.foreignKeyConfig!.getDisplayText(value);
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 40,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              displayText,
              style: const TextStyle(fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
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
              // Count display at top right
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        border: Border.all(color: Colors.blue[200]!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.format_list_numbered,
                            size: 16,
                            color: Colors.blue[700],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Số lượng: ${widget.data.length}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[700],
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                      // STT column header
                      SizedBox(
                        width: 60,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          child: const Text(
                            'STT',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
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
                                      // STT column
                                      SizedBox(
                                        width: 60,
                                        child: Container(
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(8.0),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              right: BorderSide(
                                                color: Colors.grey[300]!,
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                      ...widget.columns.map(
                                        (column) => Expanded(
                                          flex: column.width?.toInt() ?? 1,
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            child: _buildCell(
                                              column,
                                              rowData,
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
