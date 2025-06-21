import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_state.dart';
import 'package:gemstore_frontend/models/don_vi_tinh.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/format_column_data.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/qltt_create_dialog.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class DonViTinhScreen extends StatefulWidget {
  final List<DonViTinh> data;
  const DonViTinhScreen({super.key, required this.data});

  @override
  State<DonViTinhScreen> createState() => _DonViTinhScreenState();
}

class _DonViTinhScreenState extends State<DonViTinhScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'id', header: 'Mã đơn vị tính', width: 2, editable: false, customWidget: (value) => FormatColumnData.formatId(value)),
    TableColumn(key: 'name', header: 'Đơn vị tính', width: 2),
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showAddUnitDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return QlttCreateDialog(
          title: 'Thêm đơn vị tính',
          columns: _columns,
          onCreate: _onAddDonViTinh,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DonViTinhBloc, DonViTinhState>(
      listener: (context, state) {
        setState(() {
          _isLoading = state is DonViTinhStateLoading;
        });
      },
      builder: (context, state) {
        return Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              body: ReusableTableWidget(
                title: 'Đơn vị tính',
                data: DonViTinh.convertToTableRowData(widget.data),
                columns: _columns,
                onUpdate: _onUpdateDonViTinh,
                onDelete: _onDeleteDonViTinh,
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: _showAddUnitDialog,
                icon: Icon(Icons.add),
                label: Text('Thêm đơn vị tính'),
                tooltip: 'Thêm đơn vị tính',
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
      }
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  dynamic _onUpdateDonViTinh(
    TableRowData row,
    Map<String, dynamic> updatedData,
  ) {
    final String id = row.id;
    final String tenDonVi = updatedData['name'] ?? '';

    context.read<DonViTinhBloc>().add(
      DonViTinhEventUpdate(maDonVi: id, tenDonVi: tenDonVi),
    );
  }

  void _onDeleteDonViTinh(String id) {
    context.read<DonViTinhBloc>().add(DonViTinhEventDelete(maDonVi: id));
  }

  void _onAddDonViTinh(Map<String, dynamic> newData) {
    context.read<DonViTinhBloc>().add(DonViTinhEventCreate(tenDonVi: newData['name']));
  }
}
