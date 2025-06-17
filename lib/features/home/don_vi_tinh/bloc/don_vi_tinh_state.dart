import 'package:gemstore_frontend/models/don_vi_tinh.dart';

sealed class DonViTinhState {}

class DonViTinhStateInitial extends DonViTinhState {}

class DonViTinhStateLoading extends DonViTinhState {}

class DonViTinhStateUpdated extends DonViTinhState {
  final List<DonViTinh> data;

  DonViTinhStateUpdated(this.data);
}

class DonViTinhStateFailure extends DonViTinhState {
  final String error;

  DonViTinhStateFailure(this.error);
}
