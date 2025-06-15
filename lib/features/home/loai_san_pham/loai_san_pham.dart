import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh.dart';

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
      maLSP: json['maLSP'] as String,
      tenLSP: json['tenLSP'] as String,
      donViTinh: DonViTinh.fromJson(json['donViTinh']),
      loinhuan: (json['loinhuan'] as num).toDouble(),
    );
  }
}
