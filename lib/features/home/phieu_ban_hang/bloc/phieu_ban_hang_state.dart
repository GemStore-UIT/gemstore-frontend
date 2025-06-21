import 'package:gemstore_frontend/models/phieu_ban_hang.dart';

sealed class PhieuBanHangState {}

class PhieuBanHangStateInitial extends PhieuBanHangState {}

class PhieuBanHangStateLoading extends PhieuBanHangState {}

class PhieuBanHangStateUpdated extends PhieuBanHangState {
  final List<PhieuBanHang> data;

  PhieuBanHangStateUpdated(this.data);
}

class PhieuBanHangStateFailure extends PhieuBanHangState {
  final String error;

  PhieuBanHangStateFailure(this.error);
}