import 'package:gemstore_frontend/models/phieu_mua_hang.dart';

class PhieuMuaHangEvent {}

class PhieuMuaHangEventStart extends PhieuMuaHangEvent {}

class PhieuMuaHangEventGetAll extends PhieuMuaHangEvent {}

class PhieuMuaHangEventCreate extends PhieuMuaHangEvent {
  final String maNCC;
  final List<Map<String, dynamic>> sanPhamMua;

  PhieuMuaHangEventCreate({
    required this.maNCC,
    required this.sanPhamMua,
  });
}

class PhieuMuaHangEventDelete extends PhieuMuaHangEvent {
  final String maPhieu;

  PhieuMuaHangEventDelete({
    required this.maPhieu,
  });
}

class PhieuMuaHangEventUpdate extends PhieuMuaHangEvent {
  final PhieuMuaHangUpdateDto phieuMuaHang;

  PhieuMuaHangEventUpdate({
    required this.phieuMuaHang,
  });
}

