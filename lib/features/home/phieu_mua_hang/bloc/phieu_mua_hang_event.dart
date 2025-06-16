class PhieuMuaHangEvent {}

class PhieuMuaHangEventStart extends PhieuMuaHangEvent {}

class PhieuMuaHangEventGetAll extends PhieuMuaHangEvent {}

class PhieuMuaHangEventGetById extends PhieuMuaHangEvent {
  final String maPhieu;

  PhieuMuaHangEventGetById({
    required this.maPhieu,
  });
}

class PhieuMuaHangEventAdd extends PhieuMuaHangEvent {
  final String maNCC;
  final List<Map<String, dynamic>> sanPhamMua;

  PhieuMuaHangEventAdd({
    required this.maNCC,
    required this.sanPhamMua,
  });
}

