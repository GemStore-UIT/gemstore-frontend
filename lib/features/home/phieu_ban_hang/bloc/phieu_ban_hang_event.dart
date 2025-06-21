class PhieuBanHangEvent {}

class PhieuBanHangEventStart extends PhieuBanHangEvent {}

class PhieuBanHangEventGetAll extends PhieuBanHangEvent {}

class PhieuBanHangEventCreate extends PhieuBanHangEvent {
  final String khachHang;
  final List<Map<String, dynamic>> sanPhamBan;

  PhieuBanHangEventCreate({
    required this.khachHang,
    required this.sanPhamBan,
  });
}

class PhieuBanHangEventDelete extends PhieuBanHangEvent {
  final String soPhieu;

  PhieuBanHangEventDelete({
    required this.soPhieu,
  });
}

class PhieuBanHangEventUpdate extends PhieuBanHangEvent {
  final String soPhieuBH;
  final String khachHang;
  final List<Map<String, dynamic>> sanPhamBan;

  PhieuBanHangEventUpdate({
    required this.soPhieuBH,
    required this.khachHang,
    required this.sanPhamBan,
  });
}

