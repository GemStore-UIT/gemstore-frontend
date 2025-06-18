import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_state.dart';
import 'package:gemstore_frontend/models/don_vi_tinh.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class DonViTinhScreen extends StatefulWidget {
  final List<DonViTinh> data;
  const DonViTinhScreen({super.key, required this.data});

  @override
  State<DonViTinhScreen> createState() => _DonViTinhScreenState();
}

class _DonViTinhScreenState extends State<DonViTinhScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'id', header: 'Mã đơn vị tính', width: 2, editable: false),
    TableColumn(key: 'name', header: 'Đơn vị tính', width: 2),
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void _showAddUnitDialog() {
    final TextEditingController unitNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm đơn vị tính mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: unitNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên đơn vị tính',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () {
                _onAddDonViTinh(unitNameController.text);
                Navigator.of(context).pop();
              },
              child: Text('Thêm'),
            ),
          ],
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

  void _onAddDonViTinh(String tenDonVi) {
    context.read<DonViTinhBloc>().add(DonViTinhEventCreate(tenDonVi: tenDonVi));
  }
}
