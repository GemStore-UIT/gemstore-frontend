import 'package:gemstore_frontend/models/san_pham.dart';

class SanPhamEvent {}

class SanPhamEventStart extends SanPhamEvent {}

class SanPhamEventGetAll extends SanPhamEvent {}

class SanPhamEventCreate extends SanPhamEvent {
  final String tenSanPham;
  final Map<String, dynamic> loaiSanPham;
  final int donGia;
  final int tonKho;

  SanPhamEventCreate({
    required this.tenSanPham,
    required this.loaiSanPham,
    required this.donGia,
    required this.tonKho,
  });
}

class SanPhamEventDelete extends SanPhamEvent {
  final String maSanPham;

  SanPhamEventDelete({required this.maSanPham});
}

class SanPhamEventUpdate extends SanPhamEvent {
  final SanPham sanPham;

  SanPhamEventUpdate({required this.sanPham});
}
