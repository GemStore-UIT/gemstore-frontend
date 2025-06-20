import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/format.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_state.dart';
import 'package:gemstore_frontend/models/phieu_ban_hang.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuaban_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieumuaban_update_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuBanHangScreen extends StatefulWidget {
  final List<PhieuBanHang> data;
  final List<SanPham> listSanPham;

  const PhieuBanHangScreen({
    super.key,
    required this.data,
    required this.listSanPham,
  });

  @override
  State<PhieuBanHangScreen> createState() => _PhieuBanHangScreenState();
}

class _PhieuBanHangScreenState extends State<PhieuBanHangScreen> {
  late List<TableColumn> _columns;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _listSanPham = [];

  @override
  void initState() {
    super.initState();
    _listSanPham.addAll(
      widget.listSanPham.map((sp) => sp.toJson()).toList(),
    );
    _columns = [
      TableColumn(
        key: 'id',
        header: 'Mã phiếu bán hàng',
        width: 3,
        editable: false,
      ),
      TableColumn(
        key: 'name',
        header: 'Khách hàng',
        width: 3,        
      ),
      TableColumn(key: 'date', header: 'Ngày lập', width: 2),
      TableColumn(
        key: 'total',
        header: 'Tổng tiền',
        width: 2,
        customWidget:
            (value) => SizedBox(
              height: 40,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  Format.moneyFormat(value),
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
      ),
    ];
  }

  void _showAddPhieuBanHangDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhieumuahangCreateDialog(
          title: "Thêm Phiếu Bán Hàng",
          listSanPham: _listSanPham,
          onCreate: _onAddPhieuBanHang,
        );
      },
    );
  }

  void _showUpdatePhieuBanHangDialog(TableRowData row){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhieumuabanUpdateDialog(
          title: "Phiếu Bán Hàng",
          soPhieu: row.id,
          nguoiGiaoDich: row.data['name'] ?? '',
          ngayLap: row.data['date'] ?? '',
          chiTiet: row.data['details'] ?? [],
          listSanPham: _listSanPham,
          onUpdate: _onUpdatePhieuBanHang,
        );
      },
    );
  }

   @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhieuBanHangBloc, PhieuBanHangState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is PhieuBanHangStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Phiếu Bán Hàng',
                data: PhieuBanHang.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: null,
                onDelete: _onDeletePhieuBanHang,
                haveDetails: true,
                showComplexUpdateDialog: _showUpdatePhieuBanHangDialog,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddPhieuBanHangDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm Phiếu Bán Hàng'),
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

  void _onUpdatePhieuBanHang(Map<String, dynamic> updatedData) {
    final String id = updatedData['id'] ?? '';
    final String khachHang = updatedData['name'] ?? '';
    final List<Map<String, dynamic>> sanPhamBan = updatedData['details'] ?? [];

    context.read<PhieuBanHangBloc>().add(
      PhieuBanHangEventUpdate(
        soPhieuBH: id,
        khachHang: khachHang,
        sanPhamBan: sanPhamBan,
      ),
    );
     
  }

  void _onDeletePhieuBanHang(String id) {
    context.read<PhieuBanHangBloc>().add(PhieuBanHangEventDelete(soPhieu: id));
  }

  void _onAddPhieuBanHang(String khachHang, List<Map<String, dynamic>> sanPhamBan) {
    context.read<PhieuBanHangBloc>().add(
      PhieuBanHangEventCreate(khachHang: khachHang, sanPhamBan: sanPhamBan),
    );
  }
}
