import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_state.dart';
import 'package:gemstore_frontend/models/nha_cung_cap.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/qltt_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class NhaCungCapScreen extends StatefulWidget {
  final List<NhaCungCap> data;
  const NhaCungCapScreen({super.key, required this.data});

  @override
  State<NhaCungCapScreen> createState() => _NhaCungCapScreenState();
}

class _NhaCungCapScreenState extends State<NhaCungCapScreen> {
  final List<TableColumn> _columns = [
    TableColumn(
      key: 'id',
      header: 'Mã nhà cung cấp',
      width: 1,
      editable: false,
      customWidget: (value) => FormatColumnData.formatId(value),
    ),
    TableColumn(key: 'name', header: 'Tên nhà cung cấp', width: 2),
    TableColumn(key: 'address', header: 'Địa chỉ', width: 3),
    TableColumn(
      key: 'phone',
      header: 'Số điện thoại',
      width: 1,
      validator:
          (value) => !(value.trim().length < 10 || value.trim().length > 15),
      errorMessage: 'Số điện thoại phải từ 10 đến 15 ký tự',
    ),
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showAddSupplierDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return QlttCreateDialog(
          title: 'Thêm nhà cung cấp',
          columns: _columns,
          onCreate: _onAddNhaCungCap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NhaCungCapBloc, NhaCungCapState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is NhaCungCapStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Nhà Cung Cấp',
                data: NhaCungCap.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: _onUpdateNhaCungCap,
                onDelete: _onDeleteNhaCungCap,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddSupplierDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm nhà cung cấp'),
                tooltip: 'Thêm nhà cung cấp',
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  dynamic _onUpdateNhaCungCap(
    TableRowData row,
    Map<String, dynamic> updatedData,
  ) {
    final String id = row.id;
    final String name = updatedData['name'] ?? '';
    final String address = updatedData['address'] ?? '';
    final String phone = updatedData['phone'] ?? '';

    context.read<NhaCungCapBloc>().add(
      NhaCungCapEventUpdate(
        nhaCungCap: NhaCungCap(
          maNCC: id,
          tenNCC: name,
          diaChi: address,
          sdt: phone,
        ),
      ),
    );
  }

  void _onDeleteNhaCungCap(String id) {
    context.read<NhaCungCapBloc>().add(NhaCungCapEventDelete(maNCC: id));
  }

  void _onAddNhaCungCap(Map<String, dynamic> newData) {
    context.read<NhaCungCapBloc>().add(
      NhaCungCapEventCreate(
        tenNCC: newData['name'],
        diaChi: newData['address'],
        sdt: newData['phone'],
      ),
    );
  }
}
