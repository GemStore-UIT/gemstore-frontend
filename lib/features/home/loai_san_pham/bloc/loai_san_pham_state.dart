import 'package:gemstore_frontend/models/loai_san_pham.dart';

sealed class LoaiSanPhamState {}

class LoaiSanPhamStateInitial extends LoaiSanPhamState {}

class LoaiSanPhamStateLoading extends LoaiSanPhamState {}

class LoaiSanPhamStateUpdated extends LoaiSanPhamState {
  final List<LoaiSanPham> data;

  LoaiSanPhamStateUpdated(this.data);
}

class LoaiSanPhamStateFailure extends LoaiSanPhamState {
  final String error;

  LoaiSanPhamStateFailure(this.error);
}