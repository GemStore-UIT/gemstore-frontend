import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class PhieuMuaHangState {}

class PhieuMuaHangStateInitial extends PhieuMuaHangState {}

class PhieuMuaHangStateLoading extends PhieuMuaHangState {}

class PhieuMuaHangStateInitialSuccess extends PhieuMuaHangState {
  final List<TableRowData> phieuMuaHangs;
  final List<Map<String, dynamic>> listSanPham;
  final List<Map<String, dynamic>> listNhaCungCap;

  PhieuMuaHangStateInitialSuccess(this.phieuMuaHangs, this.listSanPham, this.listNhaCungCap);
}

class PhieuMuaHangStateInitialFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateInitialFailure(this.error);
}

class PhieuMuaHangStateUpdated extends PhieuMuaHangState {
  final List<TableRowData> phieuMuaHangs;

  PhieuMuaHangStateUpdated(this.phieuMuaHangs);
}

class PhieuMuaHangStateCreateFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateCreateFailure(this.error);
}

class PhieuMuaHangStateDeleteFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateDeleteFailure(this.error);
}

class PhieuMuaHangStateGetDetailSuccess extends PhieuMuaHangState {
  final PhieuMuaHang phieuMuaHang;

  PhieuMuaHangStateGetDetailSuccess(this.phieuMuaHang);
}

class PhieuMuaHangStateGetDetailFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateGetDetailFailure(this.error);
}
