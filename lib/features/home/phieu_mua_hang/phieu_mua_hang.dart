class PhieuMuaHang {
  String soPhieuMH;
  String ngayLap;
  String maNCC;
  double tongTien;

  PhieuMuaHang({
    required this.soPhieuMH,
    required this.ngayLap,
    required this.maNCC,
    required this.tongTien,
  });

  factory PhieuMuaHang.fromJson(Map<String, dynamic> json) {
    return PhieuMuaHang(
      soPhieuMH: json['soPhieuMH'],
      ngayLap: json['ngayLap'],
      maNCC: json['maNCC'],
      tongTien: json['tongTien'],
    );
  }
}