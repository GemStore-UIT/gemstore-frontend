import 'package:flutter/material.dart';

class BaseItemCard extends StatelessWidget {
  final String id;
  final String title;
  final List<Widget>? subtitles;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;
  final bool? isSelected;
  final ValueChanged<bool>? onSelected;
  final String? status;
  final Color? statusColor;
  final Color? backgroundColor;
  final bool isDense;

  const BaseItemCard({
    Key? key,
    required this.id,
    required this.title,
    this.subtitles,
    this.leading,
    this.trailing,
    this.onView,
    this.onEdit,
    this.onDelete,
    this.onTap,
    this.isSelected,
    this.onSelected,
    this.status,
    this.statusColor,
    this.backgroundColor,
    this.isDense = false,
  }) : super(key: key);

  Widget _buildDefaultTrailing() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onView != null)
          IconButton(
            icon: Icon(Icons.visibility),
            color: Colors.blue,
            tooltip: 'Xem chi tiết',
            onPressed: onView,
          ),
        if (onEdit != null)
          IconButton(
            icon: Icon(Icons.edit),
            color: Colors.orange,
            tooltip: 'Chỉnh sửa',
            onPressed: onEdit,
          ),
        if (onDelete != null)
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            tooltip: 'Xóa',
            onPressed: onDelete,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap ?? onView,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isDense ? 8 : 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isSelected != null && onSelected != null) ...[
                Checkbox(
                  value: isSelected,
                  onChanged: onSelected as ValueChanged<bool?>?,
                ),
              ],
              if (leading != null) ...[
                leading!,
                SizedBox(width: 12),
              ],
              // ================= Nội dung chính =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ID
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            id,
                            style: TextStyle(
                              fontSize: isDense ? 11 : 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue[800],
                            ),
                          ),
                        ),
                        Spacer(),
                        if (status != null)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: statusColor ?? Colors.green[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status!,
                              style: TextStyle(
                                fontSize: isDense ? 11 : 12,
                                fontWeight: FontWeight.w500,
                                color: statusColor != null
                                    ? statusColor!
                                    : Colors.green[800],
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: isDense ? 6 : 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isDense ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (subtitles != null) ...[
                      SizedBox(height: 6),
                      ...subtitles!.map(
                        (widget) => Padding(
                          padding: EdgeInsets.only(bottom: 4),
                          child: widget,
                        ),
                      )
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8),
              // ================= Hành động =================
              trailing ?? _buildDefaultTrailing(),
            ],
          ),
        ),
      ),
    );
  }
}
