import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/format.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/models/nha_cung_cap.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuaban_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuaban_update_dialog.dart';
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
  late List<TableColumn> _columns;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _listSanPham = [];
  final List<Map<String, dynamic>> _listNhaCungCap = [];

  @override
  void initState() {
    super.initState();
    _listSanPham.addAll(widget.listSanPham.map((sp) => sp.toJson()).toList());
    _listNhaCungCap.addAll(
      widget.listNhaCungCap.map((ncc) => ncc.toJson()).toList(),
    );
    _columns = [
      TableColumn(
        key: 'id',
        header: 'Mã phiếu mua hàng',
        width: 3,
        editable: false,
        customWidget: (value) => FormatColumnData.formatId(value)
      ),
      TableColumn(
        key: 'name',
        header: 'Nhà cung cấp',
        width: 3,
        isForeignKey: true,
        foreignKeyConfig: ForeignKeyConfig(
          options: _listNhaCungCap,
          valueKey: 'maNCC',
          displayKey: 'tenNCC',
        ),
      ),
      TableColumn(key: 'date', header: 'Ngày lập', width: 2, customWidget: (value) => FormatColumnData.formatDate(value)),
      TableColumn(
        key: 'total',
        header: 'Tổng tiền',
        width: 2,
        customWidget: (value) => FormatColumnData.formatMoney(value, Colors.orange),
      ),
    ];
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

  void _showUpdatePhieuMuaHangDialog(TableRowData row) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhieumuabanUpdateDialog(
          title: "Phiếu Mua Hàng",
          soPhieu: row.id,
          nguoiGiaoDich:
              _listNhaCungCap.firstWhere(
                (ncc) => ncc['tenNCC'] == row.data['name'],
              )['maNCC'],
          listNhaCungCap: _listNhaCungCap,
          ngayLap: row.data['date'] ?? '',
          chiTiet: row.data['details'] ?? [],
          listSanPham: _listSanPham,
          onUpdate: _onUpdatePhieuMuaHang,
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
                onUpdate: null,
                onDelete: _onDeletePhieuMuaHang,
                haveDetails: true,
                showComplexUpdateDialog: _showUpdatePhieuMuaHangDialog,
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

  void _onUpdatePhieuMuaHang(Map<String, dynamic> updatedData) {
    final String id = updatedData['id'] ?? '';
    final String nhaCungCap = updatedData['name'] ?? '';
    final List<Map<String, dynamic>> sanPhamMua = updatedData['details'] ?? [];

    context.read<PhieuMuaHangBloc>().add(
      PhieuMuaHangEventUpdate(
        phieuMuaHang: PhieuMuaHangUpdateDto(
          soPhieuMH: id,
          nhaCungCap: nhaCungCap,
          chiTiet:
              sanPhamMua
              
                  .map(
                    (item) => ChiTietPhieuMuaHangUpdateDto(
                      maSanPham: item['maSanPham'],
                      soLuong: item['soLuong'],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  void _onDeletePhieuMuaHang(String id) {
    context.read<PhieuMuaHangBloc>().add(PhieuMuaHangEventDelete(maPhieu: id));
  }

  void _onAddPhieuMuaHang(String maNCC, List<Map<String, dynamic>> sanPhamMua) {
    context.read<PhieuMuaHangBloc>().add(
      PhieuMuaHangEventCreate(maNCC: maNCC, sanPhamMua: sanPhamMua),
    );
  }
}
