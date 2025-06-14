import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_state.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class DonViTinhScreen extends StatefulWidget {
  const DonViTinhScreen({super.key});

  @override
  State<DonViTinhScreen> createState() => _DonViTinhScreenState();
}

class _DonViTinhScreenState extends State<DonViTinhScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'name', header: 'Đơn vị tính', width: 2),
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
          title: Text('Thêm đơn vị tính mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Mã đơn vị tính',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
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
                _onAddDonViTinhScreen(
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
      body: BlocConsumer<DonViTinhBloc, DonViTinhState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is DonViTinhLoading;
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              switch (state) {
                DonViTinhInitial() => Center(child: Text('Khởi tạo...')),
                DonViTinhLoading() => Container(), // or some placeholder
                DonViTinhFetchingSuccess() => ReusableTableWidget(
                  title: 'Nhà Cung Cấp',
                  data: state.data,
                  columns: _columns,
                  onUpdate: _onUpdateDonViTinhScreen,
                  onDelete: _onDeleteDonViTinhScreen,
                ),
                DonViTinhFetchingFailure() => Center(
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
        label: Text('Thêm đơn vị tính'),
        tooltip: 'Thêm đơn vị tính',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onUpdateDonViTinhScreen(TableRowData row) {
    context.read<DonViTinhBloc>().add(
      DonViTinhEventUpdate(
        maDonVi: row.id,
        tenDonVi: row.data['name'] as String,
      ),
    );
  }

  void _onDeleteDonViTinhScreen(String id) {
    context.read<DonViTinhBloc>().add(DonViTinhEventDelete(maDonVi: id));
  }

  void _fetchData() {
    context.read<DonViTinhBloc>().add(DonViTinhEventGetAll());
  }

  void _onAddDonViTinhScreen(String tenDonVi) {
    context.read<DonViTinhBloc>().add(
      DonViTinhEventAdd(tenDonVi: tenDonVi),
    );
  }
}
