import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham.dart';

class SanPham {
  String maSanPham;
  String tenSanPham;
  LoaiSanPham loaiSanPham;
  int donGia;
  int tonKho;

  SanPham({
    required this.maSanPham,
    required this.tenSanPham,
    required this.loaiSanPham,
    required this.donGia,
    required this.tonKho,
  });

  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      maSanPham: json['maSanPham'] as String,
      tenSanPham: json['tenSanPham'] as String,
      loaiSanPham: LoaiSanPham.fromJson(json['loaiSanPham']),
      donGia: (json['donGia'] as num).toInt(),
      tonKho: (json['tonKho'] as num).toInt(),
    );
  }
}
