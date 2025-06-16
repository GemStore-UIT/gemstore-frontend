import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class LoaiDichVuState {}

class LoaiDichVuInitial extends LoaiDichVuState {}

class LoaiDichVuLoading extends LoaiDichVuState {}

class LoaiDichVuFetchingSuccess extends LoaiDichVuState {
  final List<TableRowData> data;

  LoaiDichVuFetchingSuccess(this.data);
}

class LoaiDichVuFetchingFailure extends LoaiDichVuState {
  final String error;

  LoaiDichVuFetchingFailure(this.error);
}
