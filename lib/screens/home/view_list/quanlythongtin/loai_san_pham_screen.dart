import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_event.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_state.dart';
import 'package:gemstore_frontend/models/don_vi_tinh.dart';
import 'package:gemstore_frontend/models/loai_san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/qltt_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class LoaiSanPhamScreen extends StatefulWidget {
  final List<LoaiSanPham> data;
  final List<DonViTinh> listDonViTinh;

  const LoaiSanPhamScreen({
    super.key,
    required this.data,
    required this.listDonViTinh,
  });

  @override
  State<LoaiSanPhamScreen> createState() => _LoaiSanPhamScreenState();
}

class _LoaiSanPhamScreenState extends State<LoaiSanPhamScreen> {
  late List<TableColumn> _columns;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _columns = [
      TableColumn(
        key: 'id',
        header: 'Mã loại sản phẩm',
        width: 2,
        editable: false,
        customWidget: (value) => FormatColumnData.formatId(value),
      ),
      TableColumn(key: 'name', header: 'Tên loại sản phẩm', width: 2),
      TableColumn(
        key: 'unit',
        header: 'Đơn vị tính',
        width: 1,
        isForeignKey: true,
        foreignKeyConfig: ForeignKeyConfig(
          options:
              widget.listDonViTinh.map((dvt) {
                return dvt.toJson();
              }).toList(),
          valueKey: 'maDonVi',
          displayKey: 'tenDonVi',
        ),
      ),
      TableColumn(
        key: 'profit',
        header: 'Lợi nhuận',
        width: 1,
        customWidget: (value) => FormatColumnData.formatPercentage(value),
        validator: (value) => !(double.tryParse(value) == null || double.tryParse(value)! < 0),
        errorMessage: 'Lợi nhuận phải là lớn hơn hoặc bằng 0',
      ),
    ];
  }

  void _showAddProductTypeDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return QlttCreateDialog(
          title: 'Loại Sản Phẩm',
          columns: _columns,
          onCreate: _onAddLoaiSanPham,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoaiSanPhamBloc, LoaiSanPhamState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is LoaiSanPhamStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Loại Sản Phẩm',
                data: LoaiSanPham.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: _onUpdateLoaiSanPham,
                onDelete: _onDeleteLoaiSanPham,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddProductTypeDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm loại sản phẩm'),
                tooltip: 'Thêm loại sản phẩm',
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

  dynamic _onUpdateLoaiSanPham(
    TableRowData row,
    Map<String, dynamic> updatedData,
  ) {
    final String id = row.id;
    final String tenLSP = updatedData['name'] ?? '';
    final Map<String, dynamic> donViTinh = updatedData['unit'] ?? {};
    final String profit = updatedData['profit'] ?? '0.0';

    context.read<LoaiSanPhamBloc>().add(
      LoaiSanPhamEventUpdate(
        loaiSanPham: LoaiSanPham(
          maLSP: id,
          tenLSP: tenLSP,
          donViTinh: DonViTinh.fromJson(donViTinh),
          loiNhuan: double.tryParse(profit) ?? 0.0,
        ),
      ),
    );
  }

  void _onDeleteLoaiSanPham(String id) {
    context.read<LoaiSanPhamBloc>().add(LoaiSanPhamEventDelete(maLSP: id));
  }

  void _onAddLoaiSanPham(Map<String, dynamic> newData) {
    context.read<LoaiSanPhamBloc>().add(
      LoaiSanPhamEventCreate(
        tenLSP: newData['name'] ?? '',
        donViTinh: newData['unit'] ?? '',
        loiNhuan: double.tryParse(newData['profit'] ?? '0.0') ?? 0.0,
      ),
    );
  }
}
