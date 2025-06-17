import 'package:gemstore_frontend/models/don_vi_tinh.dart';

class LoaiSanPham {
  String maLSP;
  String tenLSP;
  DonViTinh donViTinh;
  double loinhuan;

  LoaiSanPham({
    required this.maLSP,
    required this.tenLSP,
    required this.donViTinh,
    required this.loinhuan,
  });

  factory LoaiSanPham.fromJson(Map<String, dynamic> json) {
    return LoaiSanPham(
      maLSP: json['maLSP'],
      tenLSP: json['tenLSP'],
      donViTinh: DonViTinh.fromJson(json['donViTinh']),
      loinhuan:  json['loinhuan']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maLSP': maLSP,
      'tenLSP': tenLSP,
      'donViTinh': donViTinh.toJson(),
      'loinhuan': loinhuan,
    };
  }
}
