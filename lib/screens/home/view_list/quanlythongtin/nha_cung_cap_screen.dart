import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class SupplierModel {
  final String id;
  final String name;
  final String address;
  final String phone;

  SupplierModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });
}

class NhaCungCapScreen extends StatefulWidget {
  const NhaCungCapScreen({super.key});

  @override
  State<NhaCungCapScreen> createState() => _NhaCungCapScreenState();
}

class _NhaCungCapScreenState extends State<NhaCungCapScreen> {
  List<SupplierModel> _allSuppliers = [];
  final List<TableColumn> _columns = [
    TableColumn(key: 'name', header: 'Tên nhà cung cấp', width: 2),
    TableColumn(key: 'address', header: 'Địa chỉ', width: 3),
    TableColumn(
      key: 'phone',
      header: 'Số điện thoại',
      width: 2,
      validator:
          (value) => (value.trim().length < 10 || value.trim().length > 15) ? false : true,
      errorMessage: 'Số điện thoại phải từ 10 đến 15 ký tự',
    ),
  ];
  List<TableRowData> _data = [];

  void convertToTableData() {
    _data =
        _allSuppliers.map((supplier) {
          return TableRowData(
            id: supplier.id,
            data: {
              'name': supplier.name,
              'address': supplier.address,
              'phone': supplier.phone,
            },
          );
        }).toList();
  }

  @override
  void initState() {
    super.initState();
    _initializeSuppliers();
    convertToTableData();
  }

  void _initializeSuppliers() {
    _allSuppliers = [
      SupplierModel(
        id: 'NCC001',
        name: 'Công ty TNHH ABC',
        address: '123 Đường Nguyễn Văn A, Quận 1, TP.HCM',
        phone: '0123456789',
      ),
      SupplierModel(
        id: 'NCC002',
        name: 'Công ty Cổ phần DEF',
        address: '456 Đường Lê Văn B, Quận 2, TP.HCM',
        phone: '0987654321',
      ),
      SupplierModel(
        id: 'NCC003',
        name: 'Doanh nghiệp GHI',
        address: '789 Đường Trần Văn C, Quận 3, TP.HCM',
        phone: '0369852147',
      ),
      SupplierModel(
        id: 'NCC004',
        name: 'Công ty XYZ Ltd',
        address: '321 Đường Phạm Văn D, Quận 4, TP.HCM',
        phone: '0741258963',
      ),
      SupplierModel(
        id: 'NCC005',
        name: 'Nhà cung cấp MNO',
        address: '654 Đường Hoàng Văn E, Quận 5, TP.HCM',
        phone: '0258147369',
      ),
    ];
  }

  void _showAddSupplierDialog() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm nhà cung cấp mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Mã nhà cung cấp',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'Tên nhà cung cấp',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    labelText: 'Địa chỉ',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'Số điện thoại',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                if (idController.text.isNotEmpty &&
                    nameController.text.isNotEmpty &&
                    addressController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty) {
                  // Check if ID already exists
                  bool idExists = _allSuppliers.any(
                    (s) => s.id == idController.text,
                  );
                  if (idExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mã nhà cung cấp đã tồn tại!')),
                    );
                    return;
                  }

                  setState(() {
                    _allSuppliers.add(
                      SupplierModel(
                        id: idController.text,
                        name: nameController.text,
                        address: addressController.text,
                        phone: phoneController.text,
                      ),
                    );
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Đã thêm nhà cung cấp thành công!')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Vui lòng điền đầy đủ thông tin!')),
                  );
                }
              },
              child: Text('Thêm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _onUpdateSupplier(
    String id,
    Map<String, dynamic> updatedData,
  ) async {
    try {
      // Call API by repository to update supplier
      // Simulate API call with a delay
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      return;
    }
  }

  Future<void> _onDeleteSupplier(String id) async {
    try {
      // Call API by repository to delete supplier
      // Simulate API call with a delay
      await Future.delayed(Duration(seconds: 1));
      setState(() {
        _allSuppliers.removeWhere((supplier) => supplier.id == id);
        convertToTableData();
      });
    } catch (e) {
      return;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ReusableTableWidget(
            title: 'Nhà Cung Cấp',
            data: _data,
            columns: _columns,
            onUpdate: _onUpdateSupplier,
            onDelete: _onDeleteSupplier,
          ),
        ],
      ),

      // Add Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSupplierDialog,
        icon: Icon(Icons.add),
        label: Text('Thêm NCC'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
