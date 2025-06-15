import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap.dart';

class PhieuMuaHang {
  String soPhieuMH;
  String ngayLap;
  NhaCungCap nhaCungCap;
  int tongTien;

  PhieuMuaHang({
    required this.soPhieuMH,
    required this.ngayLap,
    required this.nhaCungCap,
    required this.tongTien,
  });

  factory PhieuMuaHang.fromJson(Map<String, dynamic> json) {
    return PhieuMuaHang(
      soPhieuMH: json['soPhieuMH'],
      ngayLap: json['ngayLap'],
      nhaCungCap: NhaCungCap.fromJson(json['nhaCungCap']),
      tongTien: json['tongTien'],
    );
  }
}