import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class PhieuMuaHangState {}

class PhieuMuaHangStateInitial extends PhieuMuaHangState {}

class PhieuMuaHangStateLoading extends PhieuMuaHangState {}

class PhieuMuaHangStateSuccess extends PhieuMuaHangState {
  final List<TableRowData> phieuMuaHangs;
  final List<Map<String, dynamic>> listSanPham;

  PhieuMuaHangStateSuccess(this.phieuMuaHangs, this.listSanPham);
}

class PhieuMuaHangStateFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateFailure(this.error);
}

class PhieuMuaHangStateGetDetailSuccess extends PhieuMuaHangState {
  final PhieuMuaHang phieuMuaHang;

  PhieuMuaHangStateGetDetailSuccess(this.phieuMuaHang);
}

class PhieuMuaHangStateGetDetailFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateGetDetailFailure(this.error);
}
