import 'package:gemstore_frontend/models/loai_dich_vu.dart';

sealed class LoaiDichVuState {}

class LoaiDichVuStateInitial extends LoaiDichVuState {}

class LoaiDichVuStateLoading extends LoaiDichVuState {}

class LoaiDichVuStateUpdated extends LoaiDichVuState {
  final List<LoaiDichVu> data;

  LoaiDichVuStateUpdated(this.data);
}

class LoaiDichVuStateFailure extends LoaiDichVuState {
  final String error;

  LoaiDichVuStateFailure(this.error);
}