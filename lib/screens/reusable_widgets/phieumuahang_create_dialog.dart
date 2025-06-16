import 'package:flutter/material.dart';
import 'package:gemstore_frontend/config/money_format.dart';

class BillCreateDialog extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> listSanPham;
  final List<Map<String, dynamic>> listNhaCungCap;
  final void Function(String, List<Map<String, dynamic>>) onCreate;

  const BillCreateDialog({
    super.key,
    required this.title,
    required this.listSanPham,
    required this.listNhaCungCap,
    required this.onCreate,
  });

  @override
  State<BillCreateDialog> createState() => _BillCreateDialogState();
}

class _BillCreateDialogState extends State<BillCreateDialog> {
  final TextEditingController thanhTienController = TextEditingController();
  final TextEditingController soLuongController = TextEditingController();

  String? selectedNCC;
  String? selectedSP;
  String? tenLSP;
  String? donViTinhSP;
  String? donGiaMuaSP;
  
  List<Map<String, dynamic>> addedItems = [];
  @override
  void initState() {
    super.initState();
    soLuongController.addListener(() {
      setState(() {
        // This will trigger a rebuild when the text changes
      });
    });
  }

  void _addItem() {
    if (selectedSP != null && soLuongController.text.isNotEmpty) {
      final selectedProduct = widget.listSanPham.firstWhere(
        (sp) => sp['maSanPham'] == selectedSP,
        orElse: () => {},
      );
      
      final quantity = int.tryParse(soLuongController.text) ?? 0;
      final donGia = double.tryParse(donGiaMuaSP ?? '0') ?? 0.0;
      
      setState(() {
        // Check if product already exists in the list
        final existingIndex = addedItems.indexWhere(
          (item) => item['maSanPham'] == selectedSP,
        );
        
        if (existingIndex != -1) {
          // Product exists, update quantity and total
          final existingItem = addedItems[existingIndex];
          final newQuantity = existingItem['soLuong'] + quantity;
          final newThanhTien = newQuantity * donGia;
          
          addedItems[existingIndex] = {
            ...existingItem,
            'soLuong': newQuantity,
            'thanhTien': newThanhTien,
          };
        } else {
          // Product doesn't exist, add new item
          final thanhTien = quantity * donGia;
          addedItems.add({
            'maSanPham': selectedSP,
            'tenSanPham': selectedProduct['tenSanPham'],
            'loaiSanPham': tenLSP,
            'donViTinh': donViTinhSP,
            'donGia': donGia,
            'soLuong': quantity,
            'thanhTien': thanhTien,
          });
        }
        
        // Clear selection
        selectedSP = null;
        tenLSP = null;
        donViTinhSP = null;
        donGiaMuaSP = null;
        soLuongController.clear();
      });
    }
  }

  void _removeItem(int index) {
    setState(() {
      addedItems.removeAt(index);
    });
  }

  double _calculateTotal() {
    return addedItems.fold(0.0, (sum, item) => sum + (item['thanhTien'] ?? 0.0));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.blue, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(thickness: 2),
            
            // Form Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Information Section
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            const Text(
                              'Thông Tin Cơ Bản',
                              style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedNCC,
                              hint: const Text('Chọn Nhà Cung Cấp'),
                              decoration: InputDecoration(
                              labelText: 'Nhà Cung Cấp',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.business),
                              ),
                              items: widget.listNhaCungCap.map((ncc) {
                              return DropdownMenuItem<String>(
                                value: ncc['maNhaCungCap'],
                                child: Text(ncc['tenNhaCungCap']),
                              );
                              }).toList(),
                              onChanged: (value) {
                              setState(() {
                                selectedNCC = value;
                              });
                              },
                            ),
                            if (selectedNCC != null)
                              Builder(
                              builder: (context) {
                                final ncc = widget.listNhaCungCap.firstWhere(
                                (n) => n['maNhaCungCap'] == selectedNCC,
                                orElse: () => {},
                                );
                                return Padding(
                                padding: const EdgeInsets.only(top: 12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  Row(
                                    children: [
                                    const Icon(Icons.phone, size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Số điện thoại: ${ncc['soDienThoai'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                    const Icon(Icons.location_on, size: 18, color: Colors.grey),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Địa chỉ: ${ncc['diaChi'] ?? ''}',
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                    ],
                                  ),
                                  ],
                                ),
                                );
                              },
                              ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Product Selection Section
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Chọn Sản Phẩm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              value: selectedSP,
                              hint: const Text('Chọn Sản Phẩm'),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.inventory),
                              ),
                              items: widget.listSanPham.map((sp) {
                                return DropdownMenuItem<String>(
                                  value: sp['maSanPham'],
                                  child: Text(sp['tenSanPham']),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedSP = value;
                                  final selectedProduct = widget.listSanPham.firstWhere(
                                    (sp) => sp['maSanPham'] == value,
                                    orElse: () => {},
                                  );
                                  tenLSP = selectedProduct['loaiSanPham'];
                                  donViTinhSP = selectedProduct['donViTinh'];
                                  donGiaMuaSP = selectedProduct['donGia'].toString();
                                });
                              },
                            ),
                            
                            if (selectedSP != null) ...[
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Loại Sản Phẩm: $tenLSP', 
                                                style: const TextStyle(fontWeight: FontWeight.w500)),
                                              Text('Đơn Vị Tính: $donViTinhSP',
                                                style: const TextStyle(fontWeight: FontWeight.w500)),
                                              Text('Đơn Giá: ${MoneyFormat.format(double.tryParse(donGiaMuaSP ?? '0')?.toInt() ?? 0)}',
                                                style: const TextStyle(fontWeight: FontWeight.w500)),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: 120,
                                          child: TextField(
                                            controller: soLuongController,
                                            decoration: InputDecoration(
                                              labelText: 'Số Lượng',
                                              border: OutlineInputBorder(),
                                              isDense: true,
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),                                    ValueListenableBuilder<TextEditingValue>(
                                      valueListenable: soLuongController,
                                      builder: (context, value, child) {
                                        final isEnabled = value.text.isNotEmpty;
                                        return SizedBox(
                                          width: double.infinity,
                                          child: ElevatedButton.icon(
                                            onPressed: isEnabled ? _addItem : null,
                                            icon: const Icon(Icons.add),
                                            label: const Text('Thêm Sản Phẩm'),
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: isEnabled
                                                ? Colors.green
                                                : Colors.grey,
                                              foregroundColor: Colors.white,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Added Items Section
                    if (addedItems.isNotEmpty) ...[
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Danh Sách Sản Phẩm Đã Thêm',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.purple,
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Tổng: ${MoneyFormat.format(_calculateTotal().toInt())}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ...addedItems.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item['tenSanPham'],
                                              style: const TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text('SL: ${item['soLuong']} ${item['donViTinh']} × ${MoneyFormat.format((item['donGia'] as double).toInt())} = ${MoneyFormat.format((item['thanhTien'] as double).toInt())}'),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _removeItem(index),
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            // Action Buttons
            const Divider(thickness: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Hủy'),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: (addedItems.isNotEmpty && selectedNCC != null) ? () {
                    widget.onCreate(
                      selectedNCC!,
                      addedItems,
                    );
                    Navigator.of(context).pop();
                  } : null,
                  icon: const Icon(Icons.save),
                  label: const Text('Tạo Hóa Đơn'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    thanhTienController.dispose();
    soLuongController.dispose();
    super.dispose();
  }
}