import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang.dart';

sealed class PhieuMuaHangState {}

class PhieuMuaHangInitial extends PhieuMuaHangState {}

class PhieuMuaHangStateLoading extends PhieuMuaHangState {}

class PhieuMuaHangStateSuccess extends PhieuMuaHangState {
  final List<PhieuMuaHang> phieuMuaHangs;

  PhieuMuaHangStateSuccess(this.phieuMuaHangs);
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
