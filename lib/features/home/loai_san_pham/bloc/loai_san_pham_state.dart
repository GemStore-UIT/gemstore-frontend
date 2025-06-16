import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class LoaiSanPhamState {}

class LoaiSanPhamInitial extends LoaiSanPhamState {}

class LoaiSanPhamLoading extends LoaiSanPhamState {}

class LoaiSanPhamFetchingSuccess extends LoaiSanPhamState {
  final List<TableRowData> data;

  LoaiSanPhamFetchingSuccess(this.data);
}

class LoaiSanPhamFetchingFailure extends LoaiSanPhamState {
  final String error;

  LoaiSanPhamFetchingFailure(this.error);
}
