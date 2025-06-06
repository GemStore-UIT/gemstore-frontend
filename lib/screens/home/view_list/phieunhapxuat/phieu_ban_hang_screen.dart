import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/advanced_search_widgets.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/base_item_card.dart';
import 'package:intl/intl.dart';

class PurchaseOrderModal {
  final String id;
  final String customerName;
  final String orderDate;

  PurchaseOrderModal({
    required this.id,
    required this.customerName,
    required this.orderDate,
  });
}

class PhieuBanHangScreen extends StatefulWidget {
  const PhieuBanHangScreen({super.key});

  @override
  _PhieuBanHangScreenState createState() => _PhieuBanHangScreenState();
}

class _PhieuBanHangScreenState extends State<PhieuBanHangScreen> {
  final TextEditingController _idSearchController = TextEditingController();
  final TextEditingController _customerNameSearchController =
      TextEditingController();
  final TextEditingController _orderDateSearchController =
      TextEditingController();

  List<PurchaseOrderModal> _allPurchaseOrders = [];
  List<PurchaseOrderModal> _filteredPurchaseOrders = [];

  @override
  void initState() {
    super.initState();
    _initializePurchaseOrders();
    _idSearchController.addListener(_filterPurchaseOrders);
    _customerNameSearchController.addListener(_filterPurchaseOrders);
    _orderDateSearchController.addListener(_filterPurchaseOrders);
  }

  void _initializePurchaseOrders() {
    // Simulate fetching data from a database or API
    _allPurchaseOrders = [
      PurchaseOrderModal(
        id: 'PO001',
        customerName: 'Nguyen Van A',
        orderDate: '2023-10-01',
      ),
      PurchaseOrderModal(
        id: 'PO002',
        customerName: 'Tran Thi B',
        orderDate: '2023-10-02',
      ),
      PurchaseOrderModal(
        id: 'PO003',
        customerName: 'Le Van C',
        orderDate: '2023-10-03',
      ),
      PurchaseOrderModal(
        id: 'PO004',
        customerName: 'Le Van B ',
        orderDate: '2020-01-03',
      ),
      PurchaseOrderModal(
        id: 'PO005',
        customerName: 'Le Thi T',
        orderDate: '2005-05-23',
      ),
      PurchaseOrderModal(
        id: 'PO006',
        customerName: 'Nguyen Van M',
        orderDate: '2014-10-13',
      ),
    ];
    _filteredPurchaseOrders = List.from(_allPurchaseOrders);
  }

  void _filterPurchaseOrders() {
    setState(() {
      String idSearch = _idSearchController.text.toLowerCase().trim();
      String customerNameSearch =
          _customerNameSearchController.text.toLowerCase().trim();
      String orderDateSearch =
          _orderDateSearchController.text.toLowerCase().trim();

      if (idSearch.isEmpty &&
          customerNameSearch.isEmpty &&
          orderDateSearch.isEmpty) {
        _filteredPurchaseOrders = List.from(_allPurchaseOrders);
        return;
      }

      _filteredPurchaseOrders =
          _allPurchaseOrders.where((order) {
            bool matchesId =
                idSearch.isEmpty || order.id.toLowerCase().contains(idSearch);
            bool matchesName =
                customerNameSearch.isEmpty ||
                order.customerName.toLowerCase().contains(customerNameSearch);
            bool matchesDate =
                orderDateSearch.isEmpty ||
                order.orderDate.toLowerCase().contains(orderDateSearch);
            return (matchesId && matchesName && matchesDate);
          }).toList();
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
                  _allPurchaseOrders.removeWhere((orders) => orders.id == id);
                  _filterPurchaseOrders();
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

  void _showOrderDetails(PurchaseOrderModal purchaseorders) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Chi tiết phiếu bán hàng'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow('Mã phiếu bán hàng:', purchaseorders.id),
              SizedBox(height: 8),
              _buildDetailRow('Tên khách hàng:', purchaseorders.customerName),
              SizedBox(height: 8),
              _buildDetailRow('Ngày lập hoá đơn:', purchaseorders.orderDate),
              SizedBox(height: 8),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Đóng'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                _showEditOrderDialog(purchaseorders);
              },
              icon: Icon(Icons.edit),
              label: Text('Chỉnh sửa'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  void _showEditOrderDialog(PurchaseOrderModal purchaseorders) {
    // final TextEditingController idController = TextEditingController(text: purchaseorders.id);
    final TextEditingController customerController = TextEditingController(
      text: purchaseorders.customerName,
    );
    final TextEditingController orderdateController = TextEditingController(
      text: purchaseorders.orderDate,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: SizedBox(
            width: 500,
            height: 600,
            child: Column(
              children: [
                // Fixed Header
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.orange[700]),
                      SizedBox(width: 8),
                      Text(
                        'Chỉnh sửa thông tin phiếu bán hàng',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Read-only Supplier Code
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
                                'Mã phiếu bán hàng: ${purchaseorders.id}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(
                                    Icons.lock,
                                    size: 16,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    purchaseorders.id,
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
                                'Mã phiếu bán hàng không thể chỉnh sửa',
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

                        // Editable Address Field
                        TextField(
                          controller: customerController,
                          decoration: InputDecoration(
                            labelText: 'Tên khách hàng *',
                            hintText: 'Nhập tên khách hàng',
                            prefixIcon: Icon(Icons.location_on),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                          ),
                          maxLines: null,
                          minLines: 2,
                        ),
                        SizedBox(height: 16),

                        // Editable Order Date Field
                        TextField(
                          controller: orderdateController,
                          readOnly: true,
                          onTap: () async {
                            // Show date picker when the field is tapped
                            DateTime? selectedDate = await showDatePicker(
                              context: context,
                              initialDate:
                                  DateTime.tryParse(purchaseorders.orderDate) ??
                                  DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );
                            if (selectedDate != null) {
                              String formattedDate = DateFormat(
                                'yyyy-MM-dd',
                              ).format(selectedDate);
                              setState(() {
                                // Update the order date controller with the selected date
                                orderdateController.text = formattedDate;
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Nhập ngày lập phiếu bán hàng *',
                            hintText: 'Nhập ngày lập phiếu bán hàng',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          maxLines: 1,
                        ),
                        SizedBox(height: 12),

                        // Info message
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.orange[200]!),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.orange[700],
                                size: 16,
                              ),
                              SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  'Các trường có dấu (*) là bắt buộc',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.orange[700],
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

                // Fixed Footer with Action Buttons
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(4),
                      bottomRight: Radius.circular(4),
                    ),
                    border: Border(top: BorderSide(color: Colors.grey[200]!)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        child: Text('Hủy'),
                      ),
                      SizedBox(width: 12),
                      ElevatedButton.icon(
                        onPressed: () {
                          if (customerController.text.trim().isNotEmpty &&
                              orderdateController.text.trim().isNotEmpty) {
                            // Check if any changes were made
                            bool hasChanges =
                                customerController.text.trim() !=
                                    purchaseorders.customerName ||
                                orderdateController.text.trim() !=
                                    purchaseorders.orderDate;

                            if (!hasChanges) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Không có thay đổi nào được thực hiện',
                                  ),
                                  backgroundColor: Colors.grey[600],
                                ),
                              );
                              return;
                            }

                            // Update purchase order information
                            setState(() {
                              int index = _allPurchaseOrders.indexWhere(
                                (s) => s.id == purchaseorders.id,
                              );
                              if (index != -1) {
                                _allPurchaseOrders[index] = PurchaseOrderModal(
                                  id: purchaseorders.id, // Keep the same ID
                                  customerName: customerController.text.trim(),
                                  orderDate: orderdateController.text.trim(),
                                );
                                _filterPurchaseOrders(); // Refresh the filtered list
                              }
                            });

                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Đã cập nhật thông tin phiếu bán hàng thành công!',
                                    ),
                                  ],
                                ),
                                backgroundColor: Colors.green,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Vui lòng điền đầy đủ thông tin bắt buộc!',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.save),
                        label: Text('Cập nhật'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
        Text(value, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  void _showAddPurchaseOrderDialog() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController customerNameController =
        TextEditingController();
    final TextEditingController orderDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm phiếu bán hàng  mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Mã phiếu bán hàng',
                    border: OutlineInputBorder(),
                  ),
                ),
                // Id Field
                SizedBox(height: 16),
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Tên phiếu bán hàng',
                    border: OutlineInputBorder(),
                  ),
                ),
                // Customer Name Field
                SizedBox(height: 16),
                TextField(
                  controller: customerNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên khách hàng',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 16),
                // Order Date Field
                TextField(
                  controller: orderDateController,
                  readOnly: true,
                  onTap: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      String formattedDate = DateFormat(
                        'yyyy-MM-dd',
                      ).format(selectedDate);
                      orderDateController.text = formattedDate;
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Ngày lập phiếu bán hàng',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
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
                    customerNameController.text.isNotEmpty &&
                    orderDateController.text.isNotEmpty) {
                  // Check if ID already exists
                  bool idExists = _allPurchaseOrders.any(
                    (s) => s.id == idController.text,
                  );
                  if (idExists) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Mã phiếu bán hàng đã tồn tại!')),
                    );
                    return;
                  }

                  setState(() {
                    _allPurchaseOrders.add(
                      PurchaseOrderModal(
                        id: idController.text,
                        customerName: customerNameController.text,
                        orderDate: orderDateController.text,
                      ),
                    );
                    _filterPurchaseOrders();
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm phiếu bán hàng thành công!'),
                    ),
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
      appBar: AppBar(title: Text('Phiếu Bán Hàng')),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          AdvancedSearchWidget(
            count: 4,
            searchTerms: [
              'Số phiếu bán hàng',
              'Tên khách hàng',
              'Ngày lập phiếu',
              'Tất cả',
            ],
            iconTerms: [
              Icons.receipt,
              Icons.person,
              Icons.numbers,
              Icons.search,
            ],
            controllers: [
              _idSearchController,
              _customerNameSearchController,
              _orderDateSearchController,
              TextEditingController(),
            ],
          ),
          Expanded(
            child:
                _filteredPurchaseOrders.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Không tìm thấy phiếu bán hàng nào',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          if (_idSearchController.text.isEmpty &&
                              _customerNameSearchController.text.isEmpty &&
                              _orderDateSearchController.text.isEmpty)
                            Text(
                              'Vui lòng nhập thông tin tìm kiếm',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _filteredPurchaseOrders.length,
                      itemBuilder: (context, index) {
                        final purchaseOrder = _filteredPurchaseOrders[index];
                        return BaseItemCard(
                          id: purchaseOrder.id,
                          title: 'Khach hang: ${purchaseOrder.customerName}',
                          subtitles: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Ngày lập: ${purchaseOrder.orderDate}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ],
                          onView: () => _showOrderDetails(purchaseOrder),
                          onEdit: () => _showEditOrderDialog(purchaseOrder),
                          onDelete: () => _deleteSupplier(purchaseOrder.id),
                        );
                      },
                    ),
          ),
        ],
      ),
      // Add button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPurchaseOrderDialog,
        label: Text('Thêm phiếu bán hàng'),
        icon: Icon(Icons.add),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        tooltip: 'Thêm phiếu bán hàng',
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  @override
  void dispose() {
    _idSearchController.dispose();
    _customerNameSearchController.dispose();
    _orderDateSearchController.dispose();
    super.dispose();
  }
}
