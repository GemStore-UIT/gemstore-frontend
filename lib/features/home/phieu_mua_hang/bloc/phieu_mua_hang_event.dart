class PhieuMuaHangEvent {}

class PhieuMuaHangEventStart extends PhieuMuaHangEvent {}

class PhieuMuaHangEventGetAll extends PhieuMuaHangEvent {}

class PhieuMuaHangEventGetById extends PhieuMuaHangEvent {
  final String maPhieu;

  PhieuMuaHangEventGetById(this.maPhieu);
}

class PhieuMuaHangEventAdd extends PhieuMuaHangEvent {
  final String maNCC;
  final String ngayLap;
  double thanhTien;
  final List<Map<String, dynamic>> sanPhamMua;

  PhieuMuaHangEventAdd({
    required this.maNCC,
    required this.ngayLap,
    required this.thanhTien,
    required this.sanPhamMua,
  });
}

