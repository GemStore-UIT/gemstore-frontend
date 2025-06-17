import 'package:gemstore_frontend/models/phieu_mua_hang.dart';

sealed class PhieuMuaHangState {}

class PhieuMuaHangStateInitial extends PhieuMuaHangState {}

class PhieuMuaHangStateLoading extends PhieuMuaHangState {}

// Success state
class PhieuMuaHangStateUpdated extends PhieuMuaHangState {
  final List<PhieuMuaHang> data;

  PhieuMuaHangStateUpdated(this.data);
}

// Failure state
class PhieuMuaHangStateFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateFailure(this.error);
}