import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_event.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_state.dart';
import 'package:gemstore_frontend/models/loai_san_pham.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/qltt_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class SanPhamScreen extends StatefulWidget {
  final List<SanPham> data;
  final List<LoaiSanPham> listLoaiSanPham;

  const SanPhamScreen({
    super.key,
    required this.data,
    required this.listLoaiSanPham,
  });

  @override
  State<SanPhamScreen> createState() => _SanPhamScreenState();
}

class _SanPhamScreenState extends State<SanPhamScreen> {
  late List<TableColumn> _columns;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _columns = [
      TableColumn(
        key: 'id',
        header: 'Mã sản phẩm',
        width: 1,
        editable: false,
        customWidget: (value) => FormatColumnData.formatId(value),
      ),
      TableColumn(key: 'name', header: 'Tên sản phẩm', width: 2),
      TableColumn(
        key: 'productType',
        header: 'Loại sản phẩm',
        width: 2,
        isForeignKey: true,
        foreignKeyConfig: ForeignKeyConfig(
          options:
              widget.listLoaiSanPham.map((lsp) {
                return lsp.toJson();
              }).toList(),
          valueKey: 'maLSP',
          displayKey: 'tenLSP',
        ),
      ),
      TableColumn(
        key: 'unit',
        header: 'Đơn vị tính',
        width: 1,
        editable: false,
      ),
      TableColumn(
        key: 'price',
        header: 'Đơn giá mua vào',
        width: 2,
        customWidget:
            (value) => FormatColumnData.formatMoney(
              int.tryParse(value) ?? 0,
              Colors.orange,
            ),
        validator:
            (value) =>
                !(int.tryParse(value) == null || int.tryParse(value)! < 0),
        errorMessage: 'Đơn giá mua vào phải lớn hơn hoặc bằng 0',
      ),
      TableColumn(
        key: 'quantity',
        header: 'Số lượng tồn kho',
        width: 1,
        validator:
            (value) =>
                !(int.tryParse(value) == null || int.tryParse(value)! < 0),
        errorMessage: 'Số lượng tồn kho phải lớn hơn hoặc bằng 0',
      ),
    ];
  }

  void _showAddProductDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return QlttCreateDialog(
          title: 'Sản Phẩm',
          columns: _columns,
          onCreate: _onAddSanPham,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SanPhamBloc, SanPhamState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is SanPhamStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Sản Phẩm',
                data: SanPham.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: _onUpdateSanPham,
                onDelete: _onDeleteSanPham,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddProductDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm sản phẩm'),
                tooltip: 'Thêm sản phẩm',
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

  dynamic _onUpdateSanPham(TableRowData row, Map<String, dynamic> updatedData) {
    final String id = row.id;
    final String tenSP = updatedData['name'] ?? '';
    final Map<String, dynamic> loaiSanPham = updatedData['productType'] ?? {};
    final String price = updatedData['price'] ?? '0';
    final String quantity = updatedData['quantity'] ?? '0';

    context.read<SanPhamBloc>().add(
      SanPhamEventUpdate(
        sanPham: SanPham(
          maSanPham: id,
          tenSanPham: tenSP,
          loaiSanPham: LoaiSanPham.fromJson(loaiSanPham),
          donGia: int.tryParse(price) ?? 0,
          tonKho: int.tryParse(quantity) ?? 0,
        ),
      ),
    );
  }

  void _onDeleteSanPham(String id) {
    context.read<SanPhamBloc>().add(SanPhamEventDelete(maSanPham: id));
  }

  void _onAddSanPham(Map<String, dynamic> newData) {
    context.read<SanPhamBloc>().add(
      SanPhamEventCreate(
        tenSanPham: newData['name'] ?? '',
        loaiSanPham: newData['productType'] ?? {},
        donGia: int.tryParse(newData['price'] ?? '0') ?? 0,
        tonKho: int.tryParse(newData['quantity'] ?? '0') ?? 0,
      ),
    );
  }
}
