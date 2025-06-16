import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh.dart';

class LoaiSanPham {
  final String maLSP;
  final String tenLSP;
  final DonViTinh donViTinh;
  final double loiNhuan;

  LoaiSanPham({
    required this.maLSP,
    required this.tenLSP,
    required this.donViTinh,
    required this.loiNhuan,
  });

  factory LoaiSanPham.fromJson(Map<String, dynamic> json) {
    return LoaiSanPham(
      maLSP: json['maLSP'] as String,
      tenLSP: json['tenLSP'] as String,
      donViTinh: DonViTinh.fromJson(json['donViTinh']),
      loiNhuan: (json['loiNhuan'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maLSP': maLSP,
      'tenLSP': tenLSP,
      'donViTinh': donViTinh.toJson(),
      'loiNhuan': loiNhuan,
    };
  }

  static List<LoaiSanPham> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => LoaiSanPham.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
