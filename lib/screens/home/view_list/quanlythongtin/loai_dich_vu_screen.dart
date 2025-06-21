import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_state.dart';
import 'package:gemstore_frontend/models/loai_dich_vu.dart';
import 'package:gemstore_frontend/models/tham_so.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/qltt_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class LoaiDichVuScreen extends StatefulWidget {
  final List<LoaiDichVu> data;
  final List<ThamSo> thamSo;

  const LoaiDichVuScreen({super.key, required this.data, required this.thamSo});

  @override
  State<LoaiDichVuScreen> createState() => _LoaiDichVuScreenState();
}

class _LoaiDichVuScreenState extends State<LoaiDichVuScreen> {
  late List<TableColumn> _columns;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _columns = [
    TableColumn(
      key: 'id',
      header: 'Mã loại dịch vụ',
      width: 2,
      editable: false,
      customWidget: (value) => FormatColumnData.formatId(value),
    ),
    TableColumn(key: 'name', header: 'Tên loại dịch vụ', width: 2),
    TableColumn(
      key: 'price',
      header: 'Đơn giá',
      width: 2,
      customWidget:
          (value) => FormatColumnData.formatMoney(value, Colors.orange),
      validator:
          (value) =>
              !(int.tryParse(value) == null || int.tryParse(value)! < 0),
      errorMessage: 'Đơn giá phải lớn hơn hoặc bằng 0',
    ),
    TableColumn(
      key: 'prepaid',
      header: 'Phần trăm phải trả trước',
      width: 2,
      customWidget:
          (value) => FormatColumnData.formatPercentage(value.toString()),
      validator:
          (value) =>
              !(double.tryParse(value) == null || double.tryParse(value)! < 0),
      errorMessage: 'Phần trăm trả trước phải lớn hơn hoặc bằng 0',
      defaultData: widget.thamSo
          .firstWhere((thamSo) => thamSo.tenThamSo == 'TiLeTraTruocMacDinh')
          .giaTri.toString(),
    ),
  ];
  }

  void _showAddLoaiDichVuDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return QlttCreateDialog(
          title: 'Thêm loại dịch vụ',
          columns: _columns,
          onCreate: _onAddLoaiDichVu,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoaiDichVuBloc, LoaiDichVuState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is LoaiDichVuStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Loại Dịch Vụ',
                data: LoaiDichVu.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: _onUpdateLoaiDichVu,
                onDelete: _onDeleteLoaiDichVu,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddLoaiDichVuDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm loại dịch vụ'),
                tooltip: 'Thêm loại dịch vụ',
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

  dynamic _onUpdateLoaiDichVu(
    TableRowData row,
    Map<String, dynamic> updatedData,
  ) {
    final String id = row.id;
    final String name = updatedData['name'] ?? '';
    final int price = updatedData['price'] ?? 0;
    final double prepaid = updatedData['prepaid'] ?? 0.0;

    context.read<LoaiDichVuBloc>().add(
      LoaiDichVuEventUpdate(
        loaiDichVu: LoaiDichVu(
          maLDV: id,
          tenLDV: name,
          donGia: price,
          traTruoc: prepaid,
        ),
      ),
    );
  }

  void _onDeleteLoaiDichVu(String id) {
    context.read<LoaiDichVuBloc>().add(LoaiDichVuEventDelete(maLDV: id));
  }

  void _onAddLoaiDichVu(Map<String, dynamic> newData) {
    context.read<LoaiDichVuBloc>().add(
      LoaiDichVuEventCreate(
        tenLDV: newData['name'],
        donGia: int.tryParse(newData['price']) ?? 0,
        traTruoc: double.tryParse(newData['prepaid']) ?? 0.0,
      ),
    );
  }
}
