import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class NhaCungCapState {}

class NhaCungCapInitial extends NhaCungCapState {}

class NhaCungCapLoading extends NhaCungCapState {}

class NhaCungCapFetchingSuccess extends NhaCungCapState {
  final List<TableRowData> data;

  NhaCungCapFetchingSuccess(this.data);
}

class NhaCungCapFetchingFailure extends NhaCungCapState {
  final String error;

  NhaCungCapFetchingFailure(this.error);
}