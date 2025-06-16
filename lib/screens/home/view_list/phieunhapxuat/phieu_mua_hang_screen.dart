import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/error_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuahang_create_dialog.dart';
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
  final List<Map<String, dynamic>> _listNhaCungCap = [
    {'maNhaCungCap': 'NCC001', 'tenNhaCungCap': 'Nhà Cung Cấp 1'},
    {'maNhaCungCap': 'NCC002', 'tenNhaCungCap': 'Nhà Cung Cấp 2'},
  ];
  List<TableRowData> _data = [];

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
        return BillCreateDialog(
          title: "Thêm Phiếu Mua Hàng",
          listSanPham: _listSanPham,
          listNhaCungCap: _listNhaCungCap,
          onCreate: _onAddPhieuMuaHang,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhieuMuaHangBloc, PhieuMuaHangState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is PhieuMuaHangStateLoading;
          if (state is PhieuMuaHangStateUpdated) {
            _data = state.phieuMuaHangs;
          }
          if (state is PhieuMuaHangStateInitialSuccess) {
            _data = state.phieuMuaHangs;
            _listSanPham.clear();
            _listSanPham.addAll(state.listSanPham);
            _listNhaCungCap.clear();
            _listNhaCungCap.addAll(state.listNhaCungCap);
          }
          if (state is PhieuMuaHangStateInitialFailure) {
            _handleError('Lỗi tải dữ liệu', state.error, context);
          }
          if (state is PhieuMuaHangStateCreateFailure) {
            _handleError('Lỗi tạo phiếu mua hàng', state.error, context);
          }
          if (state is PhieuMuaHangStateDeleteFailure) {
            _handleError('Lỗi xóa phiếu mua hàng', state.error, context);
          }
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Phiếu Mua Hàng',
                data: _data,
                columns: _columns,
                onUpdate: _onUpdatePhieuMuaHang,
                onDelete: _onDeletePhieuMuaHang,                
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddPhieuMuaHangDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm Phiếu Mua Hàng'),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
            ),
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
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onUpdatePhieuMuaHang(TableRowData row) {}

  void _onDeletePhieuMuaHang(String id) {
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventDelete(maPhieu: id));
  }

  void _onGetAll() {
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventGetAll());
  }

  void _onAddPhieuMuaHang(String maNCC, List<Map<String, dynamic>> sanPhamMua) {
    context.read<PhieuMuaHangBloc>().add(
      PhieuMuaHangEventAdd(maNCC: maNCC, sanPhamMua: sanPhamMua),
    );
  }

  void _handleError(String title, String error, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(title: title, message: error);
      },
    );
  }
}
