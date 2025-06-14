import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_state.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class NhaCungCapScreen extends StatefulWidget {
  const NhaCungCapScreen({super.key});

  @override
  State<NhaCungCapScreen> createState() => _NhaCungCapScreenState();
}

class _NhaCungCapScreenState extends State<NhaCungCapScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'id', header: 'Mã nhà cung cấp', width: 1),
    TableColumn(key: 'name', header: 'Tên nhà cung cấp', width: 2),
    TableColumn(key: 'address', header: 'Địa chỉ', width: 3),
    TableColumn(
      key: 'phone',
      header: 'Số điện thoại',
      width: 2,
      validator:
          (value) =>
              (value.trim().length < 10 || value.trim().length > 15)
                  ? false
                  : true,
      errorMessage: 'Số điện thoại phải từ 10 đến 15 ký tự',
    ),
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
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
                _onAddNhaCungCap(
                  nameController.text,
                  addressController.text,
                  phoneController.text,
                );
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
      backgroundColor: Colors.white,
      body: BlocConsumer<NhaCungCapBloc, NhaCungCapState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is NhaCungCapLoading;
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              switch (state) {
                NhaCungCapInitial() => Center(child: Text('Khởi tạo...')),
                NhaCungCapLoading() => Container(), // or some placeholder
                NhaCungCapFetchingSuccess() => ReusableTableWidget(
                  title: 'Nhà Cung Cấp',
                  data: state.data,
                  columns: _columns,
                  onUpdate: _onUpdateNhaCungCap,
                  onDelete: _onDeleteNhaCungCap,
                ),
                NhaCungCapFetchingFailure() => Center(
                  child: Text('Lỗi khi tải dữ liệu: ${state.error}'),
                ),
              },
              // Loading overlay
              if (_isLoading)
                Container(
                  color: Colors.black12,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
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

  void _onUpdateNhaCungCap(TableRowData row) {
    context.read<NhaCungCapBloc>().add(
      NhaCungCapEventUpdate(
        maNCC: row.id,
        tenNCC: row.data['name'],
        diaChi: row.data['address'],
        sdt: row.data['phone'],
      ),
    );
  }

  void _onDeleteNhaCungCap(String id) {
    context.read<NhaCungCapBloc>().add(NhaCungCapEventDelete(maNCC: id));
  }

  void _fetchData() {
    context.read<NhaCungCapBloc>().add(NhaCungCapEventGetAll());
  }

  void _onAddNhaCungCap(String tenNCC, String diaChi, String sdt) {
    context.read<NhaCungCapBloc>().add(
      NhaCungCapEventAdd(tenNCC: tenNCC, diaChi: diaChi, sdt: sdt),
    );
  }
}
