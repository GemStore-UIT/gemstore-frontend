import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/config/format.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_state.dart';
import 'package:gemstore_frontend/models/loai_dich_vu.dart';
import 'package:gemstore_frontend/models/phieu_dich_vu.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/phieudichvu_update_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuDichVuScreen extends StatefulWidget {
  final List<PhieuDichVu> data;
  final List<LoaiDichVu> listLoaiDichVu;

  const PhieuDichVuScreen({
    super.key,
    required this.data,
    required this.listLoaiDichVu,
  });

  @override
  State<PhieuDichVuScreen> createState() => _PhieuDichVuScreenState();
}

class _PhieuDichVuScreenState extends State<PhieuDichVuScreen> {
  late List<TableColumn> _columns;
  bool _isLoading = false;
  final List<Map<String, dynamic>> _listLoaiDichVu = [];

  @override
  void initState() {
    super.initState();
    _listLoaiDichVu.addAll(
      widget.listLoaiDichVu.map((dv) => dv.toJson()).toList(),
    );
    _columns = [
      TableColumn(
        key: 'id',
        header: 'Mã phiếu dịch vụ',
        width: 2,
        editable: false,
        customWidget: (value) => FormatColumnData.formatId(value),
      ),
      TableColumn(key: 'name', header: 'Khách hàng', width: 2),
      TableColumn(key: 'phone', header: 'Số điện thoại', width: 2),
      TableColumn(key: 'date', header: 'Ngày lập', width: 2, customWidget: (value) => FormatColumnData.formatDate(value)),
      TableColumn(
        key: 'total',
        header: 'Tổng tiền',
        width: 2,
        customWidget:
            (value) => FormatColumnData.formatMoney(value, Colors.orange),
      ),
      TableColumn(
        key: 'totalPaid',
        header: 'Tổng tiền đã thanh toán',
        width: 2,
        customWidget:
            (value) => FormatColumnData.formatMoney(value, Colors.green),
      ),
      TableColumn(
        key: 'totalLeft',
        header: 'Tổng tiền còn lại',
        width: 2,
        customWidget:
            (value) => FormatColumnData.formatMoney(value, Colors.red),
      ),
      TableColumn(
        key: 'status',
        header: 'Trạng thái',
        width: 1,
        customWidget: (value) => FormatColumnData.formatStatus(value),
      ),
    ];
  }

  void _showAddPhieuDichVuDialog() {
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) {
    //     return PhieuDichVuCreateDialog(
    //       title: "Thêm Phiếu Dịch Vụ",
    //       listDichVu: _listDichVu,
    //       onCreate: _onAddPhieuDichVu,
    //     );
    //   },
    // );
  }

  void _showUpdatePhieuDichVuDialog(TableRowData row) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return PhieuDichVuUpdateDialog(
          title: "Cập nhật phiếu Dịch Vụ",
          soPhieuDV: row.id,
          khachhang: row.data['name'] ?? '',
          sdt: row.data['phone'] ?? '',
          ngayLap: row.data['date'] ?? '',
          chiTiet: row.data['details'] ?? [],
          listLoaiDichVu: _listLoaiDichVu,
          onUpdate: _onUpdatePhieuDichVu,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PhieuDichVuBloc, PhieuDichVuState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is PhieuDichVuStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Phiếu Dịch Vụ',
                data: PhieuDichVu.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: null,
                onDelete: _onDeletePhieuDichVu,
                haveDetails: true,
                showComplexUpdateDialog: _showUpdatePhieuDichVuDialog,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddPhieuDichVuDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm Phiếu Dịch Vụ'),
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

  void _onUpdatePhieuDichVu(Map<String, dynamic> updatedData) {
    context.read<PhieuDichVuBloc>().add(
      PhieuDichVuEventUpdate(
        soPhieuDV: updatedData['id'] ?? '',
        khachhang: updatedData['name'] ?? '',
        sdt: updatedData['phone'] ?? '',
        chiTiet: updatedData['details'] ?? [],
      ),
    );
  }

  void _onDeletePhieuDichVu(String id) {
    context.read<PhieuDichVuBloc>().add(PhieuDichVuEventDelete(soPhieuDV: id));
  }

  void _onAddPhieuDichVu(
    String khachHang,
    String sdt,
    List<Map<String, dynamic>> chiTiet,
  ) {
    context.read<PhieuDichVuBloc>().add(
      PhieuDichVuEventCreate(khachhang: khachHang, sdt: sdt, chiTiet: chiTiet),
    );
  }
}
