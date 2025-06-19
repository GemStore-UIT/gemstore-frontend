import 'package:gemstore_frontend/models/loai_san_pham.dart';

class LoaiSanPhamEvent {}

class LoaiSanPhamEventStart extends LoaiSanPhamEvent {}

class LoaiSanPhamEventGetAll extends LoaiSanPhamEvent {}

class LoaiSanPhamEventCreate extends LoaiSanPhamEvent {
  final String tenLSP;
  final Map<String, dynamic> donViTinh;
  final double loiNhuan;

  LoaiSanPhamEventCreate({
    required this.tenLSP,
    required this.donViTinh,
    required this.loiNhuan,
  });
}

class LoaiSanPhamEventUpdate extends LoaiSanPhamEvent {
  final LoaiSanPham loaiSanPham;

  LoaiSanPhamEventUpdate({required this.loaiSanPham});
}

class LoaiSanPhamEventDelete extends LoaiSanPhamEvent {
  final String maLSP;

  LoaiSanPhamEventDelete({required this.maLSP});
}