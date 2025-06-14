import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/bill_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuMuaHangScreen extends StatefulWidget {
  const PhieuMuaHangScreen({super.key});

  @override
  State<PhieuMuaHangScreen> createState() => _PhieuMuaHangScreenState();
}

class _PhieuMuaHangScreenState extends State<PhieuMuaHangScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'id', header: 'Mã phiếu mua hàng', width: 3),
    TableColumn(key: 'name', header: 'Tên nhà cung cấp', width: 3),
    TableColumn(key: 'date', header: 'Ngày lập', width: 2),
    TableColumn(key: 'total', header: 'Tổng tiền', width: 2),
  ];
  bool _isLoading = false;
  final List<Map<String, dynamic>> _listSanPham = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onGetAll();
    });
  }

  void _showAddPhieuMuaHangDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return BillCreateDialog(title: "Thêm Phiếu Mua Hàng", listSanPham: _listSanPham, onCreate: _onAddPhieuMuaHang);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<PhieuMuaHangBloc, PhieuMuaHangState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is PhieuMuaHangStateLoading;
            if (state is PhieuMuaHangStateSuccess) {
              _listSanPham.clear();
              _listSanPham.addAll(state.listSanPham);
            }
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              switch (state) {
                PhieuMuaHangStateInitial() => Center(
                  child: Text('Khởi tạo...'),
                ),
                PhieuMuaHangStateLoading() =>
                  Container(), // or some placeholder
                PhieuMuaHangStateSuccess() => ReusableTableWidget(
                  title: 'Phiếu Mua Hàng',
                  data: state.phieuMuaHangs,
                  columns: _columns,
                  onUpdate: _onUpdatePhieuMuaHang,
                  onDelete: _onDeletePhieuMuaHang,
                ),
                PhieuMuaHangStateFailure() => Center(
                  child: Text('Lỗi khi tải dữ liệu: ${state.error}'),
                ),
                PhieuMuaHangStateGetDetailSuccess() => Center(
                  child: Text('Chi tiết phiếu mua hàng: ${state.phieuMuaHang}'),
                ),
                PhieuMuaHangStateGetDetailFailure() => Center(
                  child: Text('Lỗi khi lấy chi tiết: ${state.error}'),
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
        onPressed: _showAddPhieuMuaHangDialog,
        icon: Icon(Icons.add),
        label: Text('Thêm Phiếu Mua Hàng'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onUpdatePhieuMuaHang(TableRowData row) {}

  void _onDeletePhieuMuaHang(String id) {}

  void _onGetAll() {
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventGetAll());
  }

  void _onAddPhieuMuaHang(
    String maNCC,
    String ngayLap,
    double thanhTien,
    List<Map<String, dynamic>> sanPhamMua,
  ) {
    context.read<PhieuMuaHangBloc>().add(
      PhieuMuaHangEventAdd(
        maNCC: maNCC,
        ngayLap: ngayLap,
        thanhTien: thanhTien,
        sanPhamMua: sanPhamMua,
      ),
    );
  }
}
