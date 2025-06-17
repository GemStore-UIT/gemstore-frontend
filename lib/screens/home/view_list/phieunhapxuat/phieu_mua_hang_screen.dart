import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/models/nha_cung_cap.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuahang_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuMuaHangScreen extends StatefulWidget {
  final List<PhieuMuaHang> data;
  final List<NhaCungCap> listNhaCungCap;
  final List<SanPham> listSanPham;
  const PhieuMuaHangScreen({
    super.key,
    required this.data,
    required this.listNhaCungCap,
    required this.listSanPham,
  });

  @override
  State<PhieuMuaHangScreen> createState() => _PhieuMuaHangScreenState();
}

class _PhieuMuaHangScreenState extends State<PhieuMuaHangScreen> {
  final List<TableColumn> _columns = [
    TableColumn(
      key: 'id',
      header: 'Mã phiếu mua hàng',
      width: 3,
      editable: false,
    ),
    TableColumn(key: 'name', header: 'Tên nhà cung cấp', width: 3),
    TableColumn(key: 'date', header: 'Ngày lập', width: 2),
    TableColumn(key: 'total', header: 'Tổng tiền', width: 2),
  ];
  bool _isLoading = false;
  final List<Map<String, dynamic>> _listSanPham = [];
  final List<Map<String, dynamic>> _listNhaCungCap = [];

  @override
  void initState() {
    super.initState();
    _listSanPham.addAll(
      widget.listSanPham.map((sp) => sp.toJson()).toList(),
    );
    _listNhaCungCap.addAll(
      widget.listNhaCungCap.map((ncc) => ncc.toJson()).toList(),
    );
  }

  void _showAddPhieuMuaHangDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhieumuahangCreateDialog(
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
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Phiếu Mua Hàng',
                data: PhieuMuaHang.convertToTableRowData(widget.data),
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

  dynamic _onUpdatePhieuMuaHang(
    TableRowData row,
    Map<String, dynamic> updatedData,
  ) {}

  void _onDeletePhieuMuaHang(String id) {
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventDelete(maPhieu: id));
  }

  void _onAddPhieuMuaHang(String maNCC, List<Map<String, dynamic>> sanPhamMua) {
    context.read<PhieuMuaHangBloc>().add(
      PhieuMuaHangEventCreate(maNCC: maNCC, sanPhamMua: sanPhamMua),
    );
  }
}
