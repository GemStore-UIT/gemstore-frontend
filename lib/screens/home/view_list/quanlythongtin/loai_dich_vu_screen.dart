import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_state.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';



class LoaiDichVuScreen extends StatefulWidget {
  const LoaiDichVuScreen({super.key});

  @override
  State<LoaiDichVuScreen> createState() => _LoaiDichVuScreenState();
}

class _LoaiDichVuScreenState extends State<LoaiDichVuScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'id', header: 'Mã loại dịch vụ', width: 2),
    TableColumn(key: 'name', header: 'Tên loại dịch vụ', width: 2),
    TableColumn(key: 'price', header: 'Đơn giá', width: 2),
    TableColumn(key: 'prepaid', header: 'Trả trước', width: 2),
  ];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _showAddUnitDialog() {
    final TextEditingController idController = TextEditingController();
    final TextEditingController unitNameController = TextEditingController();


    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thêm loại dịch vụ mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Mã loại dịch vụ',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: unitNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên loại dịch vụ',
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
                _onAddLoaiDichVu(
                  unitNameController.text,
                );
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<LoaiDichVuBloc, LoaiDichVuState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is LoaiDichVuLoading;
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              switch (state) {
                LoaiDichVuInitial() => Center(child: Text('Khởi tạo...')),
                LoaiDichVuLoading() => Container(), // or some placeholder
                LoaiDichVuFetchingSuccess() => ReusableTableWidget(
                  title: 'Loại Dịch Vụ',
                  data: state.data,
                  columns: _columns,
                  onUpdate: _onUpdateLoaiDichVu,
                  onDelete: _onDeleteLoaiDichVu,
                ),
                LoaiDichVuFetchingFailure() => Center(
                  child: Text('Lỗi khi tải dữ liệu: ${state.error}'),
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
        onPressed: _showAddUnitDialog,
        icon: Icon(Icons.add),
        label: Text('Thêm loại dịch vụ'),
        tooltip: 'Thêm loại dịch vụ',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onUpdateLoaiDichVu(TableRowData row) {
    context.read<LoaiDichVuBloc>().add(
      LoaiDichVuEventUpdate(
        maLoaiDV: row.data['id'],
        tenLoaiDV: row.data['name'] as String,
        donGia: row.data['price'] as double? ?? 0.0,
        traTruoc: row.data['prepaid'] as double? ?? 0.0,
      ),

    );
  }

  void _onDeleteLoaiDichVu(String id) {
    context.read<LoaiDichVuBloc>().add(LoaiDichVuEventDelete(maLoaiDV: id));
  }

  void _fetchData() {
    context.read<LoaiDichVuBloc>().add(LoaiDichVuEventGetAll());
  }

  void _onAddLoaiDichVu(String name) {
    context.read<LoaiDichVuBloc>().add(
      LoaiDichVuEventAdd(tenLoaiDV: name, donGia: 0.0, traTruoc: 0.0),
    );
  }
}
