import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_event.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_state.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';


class LoaiSanPhamScreen extends StatefulWidget {
  const LoaiSanPhamScreen({super.key});

  @override
  State<LoaiSanPhamScreen> createState() => _LoaiSanPhamScreenState();
}

class _LoaiSanPhamScreenState extends State<LoaiSanPhamScreen> {
  final List<TableColumn> _columns = [
    TableColumn(key: 'id', header: 'Mã loại sản phẩm', width: 1),
    TableColumn(key: 'name', header: 'Tên loại sản phẩm', width: 3),
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
          title: Text('Thêm loại sản phẩm mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: idController,
                  decoration: InputDecoration(
                    labelText: 'Mã loại sản phẩm',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: unitNameController,
                  decoration: InputDecoration(
                    labelText: 'Tên loại sản phẩm',
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
                _onAddLoaiSanPham(
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
      body: BlocConsumer<LoaiSanPhamBloc, LoaiSanPhamState>(
        listener: (context, state) {
          setState(() {
            _isLoading = state is LoaiSanPhamLoading;
          });
        },
        builder: (context, state) {
          return Stack(
            children: [
              switch (state) {
                LoaiSanPhamInitial() => Center(child: Text('Khởi tạo...')),
                LoaiSanPhamLoading() => Container(), // or some placeholder
                LoaiSanPhamFetchingSuccess() => ReusableTableWidget(
                  title: 'Loại Sản Phẩm',
                  data: state.data,
                  columns: _columns,
                  onUpdate: _onUpdateLoaiSanPham,
                  onDelete: _onDeleteLoaiSanPham,
                ),
                LoaiSanPhamFetchingFailure() => Center(
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
        label: Text('Thêm loại sản phẩm'),
        tooltip: 'Thêm loại sản phẩm',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onUpdateLoaiSanPham(TableRowData row) {
    context.read<LoaiSanPhamBloc>().add(
      LoaiSanPhamEventUpdate(
        maLoaiSP: row.data['id'],
        tenLoaiSP: row.data['name'] as String,
        donViTinh: row.data['donViTinh'] as String? ?? '',
        loiNhuan: row.data['loiNhuan'] as double? ?? 0.0,
      ),

    );
  }

  void _onDeleteLoaiSanPham(String id) {
    context.read<LoaiSanPhamBloc>().add(LoaiSanPhamEventDelete(maLoaiSP: id));
  }

  void _fetchData() {
    context.read<LoaiSanPhamBloc>().add(LoaiSanPhamEventGetAll());
  }

  void _onAddLoaiSanPham(String name) {
    context.read<LoaiSanPhamBloc>().add(
      LoaiSanPhamEventAdd(tenLoaiSP: name),
    );
  }
}
