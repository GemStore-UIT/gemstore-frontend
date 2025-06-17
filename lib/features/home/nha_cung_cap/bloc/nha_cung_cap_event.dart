import 'package:gemstore_frontend/models/nha_cung_cap.dart';

class NhaCungCapEvent {}

class NhaCungCapEventStart extends NhaCungCapEvent {}

class NhaCungCapEventGetAll extends NhaCungCapEvent {}

class NhaCungCapEventCreate extends NhaCungCapEvent {
  final String tenNCC;
  final String diaChi;
  final String sdt;

  NhaCungCapEventCreate({
    required this.tenNCC,
    required this.diaChi,
    required this.sdt,
  });
}

class NhaCungCapEventUpdate extends NhaCungCapEvent {
  final NhaCungCap nhaCungCap;

  NhaCungCapEventUpdate({required this.nhaCungCap});
}

class NhaCungCapEventDelete extends NhaCungCapEvent {
  final String maNCC;

  NhaCungCapEventDelete({required this.maNCC});
}
