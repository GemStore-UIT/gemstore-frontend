import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/home/view_list/quanlythongtin/nha_cung_cap_screen.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedFunction;
  String? selectedTitle;
  bool isInfoManagementExpanded = true;
  bool isInvoiceManagementExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Home_Screen',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Menu
                  Container(
                    width: 260,
                    margin: const EdgeInsets.only(left: 16.0, right: 8.0, bottom: 16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Column(
                      children: [
                        // App Bar with Product Name and Settings
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Text(
                                'Product_name',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.settings),
                                onPressed: () {
                                  _onSettingsPressed();
                                },
                              ),
                            ],
                          ),
                        ),
                        
                        // Main Content Area
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ListView(
                              children: [
                                // Information Management Section
                                _buildExpandableSection(
                                  title: 'Quản lý thông tin',
                                  isExpanded: isInfoManagementExpanded,
                                  onTap: () {
                                    setState(() {
                                      isInfoManagementExpanded = !isInfoManagementExpanded;
                                    });
                                  },
                                  items: isInfoManagementExpanded ? [
                                    _buildMenuItem('Nhà cung cấp', 'supplier_management'),
                                    _buildMenuItem('Đơn vị tính', 'unit_management'),
                                    _buildMenuItem('Loại sản phẩm', 'product_type_management'),
                                    _buildMenuItem('Loại dịch vụ', 'service_type_management'),
                                  ] : [],
                                ),
                                const SizedBox(height: 16.0),
                                
                                // Import Export Section
                                _buildExpandableSection(
                                  title: 'Phiếu nhập xuất',
                                  isExpanded: isInvoiceManagementExpanded,
                                  onTap: () {
                                    setState(() {
                                      isInvoiceManagementExpanded = !isInvoiceManagementExpanded;
                                    });
                                  },
                                  items: isInvoiceManagementExpanded ? [
                                    _buildMenuItem('Phiếu bán hàng', 'sales_invoice'),
                                    _buildMenuItem('Phiếu mua hàng', 'purchase_invoice'),
                                    _buildMenuItem('Phiếu dịch vụ', 'service_invoice'),
                                  ] : [],
                                ),
                                const SizedBox(height: 16.0),
                                
                                // Product List Section
                                _buildMenuItemWithDot('Danh sách sản phẩm', 'product_list'),
                                const SizedBox(height: 16.0),
                                
                                // Reports Section
                                _buildMenuItemWithDot('Báo cáo', 'reports'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Right side - Function screen
                  if (selectedFunction != null)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Column(
                          children: [
                            // Function screen header
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(color: Colors.black12, width: 1.0),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    selectedTitle ?? '',
                                    style: const TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            // Function screen content
                            Expanded(
                              child: Center(
                                child: _buildFunctionScreen(),
                              ),
                            ),
                          ],
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
  }

  Widget _buildExpandableSection({
    required String title, 
    required List<Widget> items,
    required bool isExpanded,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20.0),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 4.0),
                Icon(
                  isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, 
                  size: 20.0
                ),
              ],
            ),
          ),
        ),
        if (isExpanded)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items,
            ),
          ),
      ],
    );
  }

  Widget _buildMenuItem(String title, String functionId) {
    final isSelected = selectedFunction == functionId;
    final dotSize = 12.0;
    
    return InkWell(
      onTap: () {
        setState(() {
          selectedFunction = functionId;
          selectedTitle = title;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          height: 24.0,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? Colors.blue : Colors.black,
                  ),
                ),
              ),
              Container(
                width: dotSize,
                height: dotSize,
                decoration: BoxDecoration(
                  color: Colors.red[200],
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItemWithDot(String title, String functionId) {
    final isSelected = selectedFunction == functionId;
    final dotSize = 12.0;
    
    return InkWell(
      onTap: () {
        setState(() {
          selectedFunction = functionId;
          selectedTitle = title;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(20.0),
          border: isSelected 
              ? Border.all(color: Colors.blue, width: 2.0) 
              : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                  color: isSelected ? Colors.blue : Colors.black,
                ),
              ),
            ),
            Container(
              width: dotSize,
              height: dotSize,
              decoration: BoxDecoration(
                color: Colors.red[200],
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildFunctionScreen() {
    // Return specific UI based on the selected function
    switch (selectedFunction) {
      case 'supplier_management':
        return NhaCungCapScreen();
      case 'unit_management':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.straighten, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Đơn vị tính Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'product_type_management':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Loại sản phẩm Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'service_type_management':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.miscellaneous_services, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Loại dịch vụ Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'sales_invoice':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Phiếu bán hàng Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'purchase_invoice':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Phiếu mua hàng Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'service_invoice':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.home_repair_service, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Phiếu dịch vụ Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'product_list':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Danh sách sản phẩm Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      case 'reports':
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Báo cáo Screen', style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
      default:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.touch_app, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('Select a function from the menu', 
                style: TextStyle(fontSize: 20, color: Colors.grey[600])),
          ],
        );
    }
  }

  void _onSettingsPressed() {
    GoRouter.of(context).go('/settings');
  }
}