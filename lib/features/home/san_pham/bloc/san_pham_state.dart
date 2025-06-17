import 'package:gemstore_frontend/models/san_pham.dart';

sealed class SanPhamState {}

class SanPhamStateInitial extends SanPhamState {}

class SanPhamStateLoading extends SanPhamState {}

class SanPhamStateUpdated extends SanPhamState {
  final List<SanPham> data;

  SanPhamStateUpdated({required this.data});
}

class SanPhamStateFailure extends SanPhamState {
  final String error;

  SanPhamStateFailure({required this.error});
}
