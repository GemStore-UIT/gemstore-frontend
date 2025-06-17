import 'package:gemstore_frontend/models/nha_cung_cap.dart';

sealed class NhaCungCapState {}

class NhaCungCapStateInitial extends NhaCungCapState {}

class NhaCungCapStateLoading extends NhaCungCapState {}

class NhaCungCapStateUpdated extends NhaCungCapState {
  final List<NhaCungCap> data;

  NhaCungCapStateUpdated(this.data);
}

class NhaCungCapStateFailure extends NhaCungCapState {
  final String error;

  NhaCungCapStateFailure(this.error);
}