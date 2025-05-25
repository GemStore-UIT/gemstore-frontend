import 'package:flutter/material.dart';

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

class SupplierScreen extends StatefulWidget {
  const SupplierScreen({super.key});

  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends State<SupplierScreen> {
  final TextEditingController _idSearchController = TextEditingController();
  final TextEditingController _nameSearchController = TextEditingController();
  final TextEditingController _addressSearchController = TextEditingController();
  final TextEditingController _phoneSearchController = TextEditingController();
  
  List<SupplierModel> _allSuppliers = [];
  List<SupplierModel> _filteredSuppliers = [];
  bool _isAdvancedSearch = false;

  @override
  void initState() {
    super.initState();
    _initializeSuppliers();
    _idSearchController.addListener(_filterSuppliers);
    _nameSearchController.addListener(_filterSuppliers);
    _addressSearchController.addListener(_filterSuppliers);
    _phoneSearchController.addListener(_filterSuppliers);
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
    _filteredSuppliers = List.from(_allSuppliers);
  }

  void _filterSuppliers() {
    setState(() {
      String idSearch = _idSearchController.text.toLowerCase().trim();
      String nameSearch = _nameSearchController.text.toLowerCase().trim();
      String addressSearch = _addressSearchController.text.toLowerCase().trim();
      String phoneSearch = _phoneSearchController.text.toLowerCase().trim();

      // If all search fields are empty, show all suppliers
      if (idSearch.isEmpty && nameSearch.isEmpty && addressSearch.isEmpty && phoneSearch.isEmpty) {
        _filteredSuppliers = List.from(_allSuppliers);
        return;
      }

      _filteredSuppliers = _allSuppliers.where((supplier) {
        bool matchesId = idSearch.isEmpty || supplier.id.toLowerCase().contains(idSearch);
        bool matchesName = nameSearch.isEmpty || supplier.name.toLowerCase().contains(nameSearch);
        bool matchesAddress = addressSearch.isEmpty || supplier.address.toLowerCase().contains(addressSearch);
        bool matchesPhone = phoneSearch.isEmpty || supplier.phone.toLowerCase().contains(phoneSearch);
        
        // All non-empty search criteria must match (AND logic)
        return matchesId && matchesName && matchesAddress && matchesPhone;
      }).toList();
    });
  }

  void _clearSearch() {
    setState(() {
      _idSearchController.clear();
      _nameSearchController.clear();
      _addressSearchController.clear();
      _phoneSearchController.clear();
    });
  }

  void _deleteSupplier(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận xóa'),
          content: Text('Bạn có chắc chắn muốn xóa nhà cung cấp này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _allSuppliers.removeWhere((supplier) => supplier.id == id);
                  _filterSuppliers();
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Đã xóa nhà cung cấp thành công!')),
                );
              },
              child: Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showSupplierDetails(SupplierModel supplier) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi tiết nhà cung cấp'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Mã NCC:', supplier.id),
              SizedBox(height: 8),
              _buildDetailRow('Tên:', supplier.name),
              SizedBox(height: 8),
              _buildDetailRow('Địa chỉ:', supplier.address),
              SizedBox(height: 8),
              _buildDetailRow('Số điện thoại:', supplier.phone),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
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
                  bool idExists = _allSuppliers.any((s) => s.id == idController.text);
                  if (idExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mã nhà cung cấp đã tồn tại!')),
                    );
                    return;
                  }

                  setState(() {
                    _allSuppliers.add(SupplierModel(
                      id: idController.text,
                      name: nameController.text,
                      address: addressController.text,
                      phone: phoneController.text,
                    ));
                    _filterSuppliers();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Advanced Search Container
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
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
                        if (_idSearchController.text.isNotEmpty ||
                            _nameSearchController.text.isNotEmpty ||
                            _addressSearchController.text.isNotEmpty ||
                            _phoneSearchController.text.isNotEmpty)
                          TextButton.icon(
                            onPressed: _clearSearch,
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
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _idSearchController,
                          decoration: InputDecoration(
                            labelText: 'Mã nhà cung cấp',
                            hintText: 'VD: NCC001',
                            prefixIcon: Icon(Icons.tag, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _nameSearchController,
                          decoration: InputDecoration(
                            labelText: 'Tên nhà cung cấp',
                            hintText: 'VD: Công ty ABC',
                            prefixIcon: Icon(Icons.business, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _addressSearchController,
                          decoration: InputDecoration(
                            labelText: 'Địa chỉ',
                            hintText: 'VD: Quận 1, TP.HCM',
                            prefixIcon: Icon(Icons.location_on, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phoneSearchController,
                          decoration: InputDecoration(
                            labelText: 'Số điện thoại',
                            hintText: 'VD: 0123456789',
                            prefixIcon: Icon(Icons.phone, size: 20),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            isDense: true,
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue[700], size: 16),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Nhập vào các trường để tìm kiếm kết hợp. VD: Tên="ABC" và SĐT="0123" sẽ tìm các NCC có tên chứa "ABC" và SĐT chứa "0123"',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          // Supplier List
          Expanded(
            child: _filteredSuppliers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'Không tìm thấy nhà cung cấp nào',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        if (_idSearchController.text.isNotEmpty ||
                            _nameSearchController.text.isNotEmpty ||
                            _addressSearchController.text.isNotEmpty ||
                            _phoneSearchController.text.isNotEmpty) ...[
                          SizedBox(height: 8),
                          Text(
                            'Thử điều chỉnh bộ lọc tìm kiếm',
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _clearSearch,
                            icon: Icon(Icons.clear),
                            label: Text('Xóa bộ lọc'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[200],
                              foregroundColor: Colors.grey[700],
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = _filteredSuppliers[index];
                      return Card(
                        margin: EdgeInsets.only(bottom: 12),
                        elevation: 2,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // Supplier Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue[100],
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            supplier.id,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue[800],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      supplier.name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      supplier.address,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                                        SizedBox(width: 4),
                                        Text(
                                          supplier.phone,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // Action Buttons
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () => _showSupplierDetails(supplier),
                                    icon: Icon(Icons.visibility),
                                    color: Colors.blue,
                                    tooltip: 'Xem chi tiết',
                                  ),
                                  IconButton(
                                    onPressed: () => _deleteSupplier(supplier.id),
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                    tooltip: 'Xóa',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
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
    _idSearchController.dispose();
    _nameSearchController.dispose();
    _addressSearchController.dispose();
    _phoneSearchController.dispose();
    super.dispose();
  }
}