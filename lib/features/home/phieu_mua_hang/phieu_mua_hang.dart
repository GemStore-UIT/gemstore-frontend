import 'package:gemstore_frontend/features/home/san_pham/san_pham.dart';

class PhieuMuaHang {
  String soPhieuMH;
  String ngayLap;
  String maNCC;
  double tongTien;
  List<SanPham> chiTietPhieuMH;

  PhieuMuaHang({
    required this.soPhieuMH,
    required this.ngayLap,
    required this.maNCC,
    required this.tongTien,
    required this.chiTietPhieuMH,
  });

  Map<String, dynamic> toJson() {
    return {
      'ngayLap': ngayLap,
      'maNCC': maNCC,
      'tongTien': tongTien,
      'chiTietPhieuMH': chiTietPhieuMH.map((sp) => sp.toPhieuMuaHang()).toList(),
    };
  }
}
