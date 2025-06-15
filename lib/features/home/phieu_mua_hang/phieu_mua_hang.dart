class PhieuMuaHang {
  String soPhieuMH;
  String ngayLap;
  String tenNhaCungCap;
  int tongTien;
  List<SanPhamMua> chiTiet;

  PhieuMuaHang({
    required this.soPhieuMH,
    required this.ngayLap,
    required this.tenNhaCungCap,
    required this.tongTien,
    required this.chiTiet,
  });

  factory PhieuMuaHang.fromJson(Map<String, dynamic> json) {
    return PhieuMuaHang(
      soPhieuMH: json['soPhieuMH'],
      ngayLap: json['ngayLap'],
      tenNhaCungCap: json['tenNhaCungCap'],
      tongTien: json['tongTien'],
      chiTiet: (json['chiTiet'] as List)
          .map((item) => SanPhamMua.fromJson(item))
          .toList(),
    );
  }
}

class SanPhamMua {
  String maSanPham;
  String tenSanPham;
  int soLuong;
  int thanhTien;

  SanPhamMua({
    required this.maSanPham,
    required this.tenSanPham,
    required this.soLuong,
    required this.thanhTien,
  });

  factory SanPhamMua.fromJson(Map<String, dynamic> json) {
    return SanPhamMua(
      maSanPham: json['maSanPham'],
      tenSanPham: json['tenSanPham'],
      soLuong: json['soLuong'],
      thanhTien: json['thanhTien'],
    );
  }
}
