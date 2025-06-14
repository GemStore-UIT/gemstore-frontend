import 'package:flutter/material.dart';

class AdvancedSearchWidget extends StatefulWidget {
  final int count;
  final List<String> searchTerms;
  final List<IconData> iconTerms;
  final List<TextEditingController> controllers;

  const AdvancedSearchWidget({
    super.key,
    required this.count,
    required this.searchTerms,
    required this.iconTerms,
    required this.controllers,
  });

  @override
  State<AdvancedSearchWidget> createState() => _AdvancedSearchWidgetState();
}

class _AdvancedSearchWidgetState extends State<AdvancedSearchWidget> {
  bool _isAdvancedSearch = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.shade300,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Toggle Advanced Search
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tìm kiếm nâng cao',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              Row(
                children: [
                  if (widget.controllers.any((controller) => controller.text.isNotEmpty))
                    TextButton.icon(
                      onPressed: () {
                        for (var controller in widget.controllers) {
                          controller.clear();
                        }
                      },
                      icon: Icon(Icons.clear, size: 16),
                      label: Text('Xóa tất cả'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _isAdvancedSearch = !_isAdvancedSearch;
                      });                      
                    },
                    icon: Icon(
                      _isAdvancedSearch ? Icons.expand_less : Icons.expand_more,
                      color: Colors.blue[800],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Advanced Search Fields
          if (_isAdvancedSearch) ...[
            for (int i = 0; i < widget.count; i += 2)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildSearchField(
                        controller: widget.controllers[i],
                        label: widget.searchTerms[i],
                        icon: widget.iconTerms[i],
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (i + 1 < widget.count)
                      Expanded(
                        child: _buildSearchField(
                          controller: widget.controllers[i + 1],
                          label: widget.searchTerms[i + 1],
                          icon: widget.iconTerms[i + 1],
                        ),
                      )
                    else
                      Expanded(child: SizedBox()), // giữ cân đối nếu count lẻ
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        isDense: true,
      ),
    );
  }
}
