class PhieuDichVuEvent {}

class PhieuDichVuEventStart extends PhieuDichVuEvent {}

class PhieuDichVuEventGetAll extends PhieuDichVuEvent {}

class PhieuDichVuEventCreate extends PhieuDichVuEvent {
  final String khachhang;
  final String sdt;
  final List<Map<String, dynamic>> chiTiet;

  PhieuDichVuEventCreate({
    required this.khachhang,
    required this.sdt,
    required this.chiTiet,
  });
}

class PhieuDichVuEventDelete extends PhieuDichVuEvent {
  final String soPhieuDV;

  PhieuDichVuEventDelete({
    required this.soPhieuDV,
  });
}

class PhieuDichVuEventUpdate extends PhieuDichVuEvent {
  final String soPhieuDV;
  final String khachhang;
  final String sdt;
  final List<Map<String, dynamic>> chiTiet;

  PhieuDichVuEventUpdate({
    required this.soPhieuDV,
    required this.khachhang,
    required this.sdt,
    required this.chiTiet,
  });
}
