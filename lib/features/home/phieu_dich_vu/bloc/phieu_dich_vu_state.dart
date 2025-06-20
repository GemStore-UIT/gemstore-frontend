import 'package:gemstore_frontend/models/phieu_dich_vu.dart';

sealed class PhieuDichVuState {}

class PhieuDichVuStateInitial extends PhieuDichVuState {}

class PhieuDichVuStateLoading extends PhieuDichVuState {}

class PhieuDichVuStateUpdated extends PhieuDichVuState {
  final List<PhieuDichVu> data;

  PhieuDichVuStateUpdated(this.data);
}

class PhieuDichVuStateError extends PhieuDichVuState {
  final String message;

  PhieuDichVuStateError(this.message);
}