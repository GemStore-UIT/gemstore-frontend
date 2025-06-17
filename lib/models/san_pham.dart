import 'package:gemstore_frontend/models/loai_san_pham.dart';

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
      maSanPham:  json['maSanPham'],
      tenSanPham: json['tenSanPham'],
      loaiSanPham: LoaiSanPham.fromJson(json['loaiSanPham'] as Map<String, dynamic>),
      donGia: json['donGia'],
      tonKho: json['tonKho'],
    );
  }

  static List<SanPham> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SanPham.fromJson(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'maSanPham': maSanPham,
      'tenSanPham': tenSanPham,
      'loaiSanPham': loaiSanPham.toJson(),
      'donGia': donGia,
      'tonKho': tonKho,
    };
  }
}
