class NhaCungCapEvent {}

class NhaCungCapEventStart extends NhaCungCapEvent {}

class NhaCungCapEventGetAll extends NhaCungCapEvent {}

class NhaCungCapEventGetById extends NhaCungCapEvent {
  final String maNCC;

  NhaCungCapEventGetById(this.maNCC);
}

class NhaCungCapEventAdd extends NhaCungCapEvent {
  final String tenNCC;
  final String diaChi;
  final String sdt;

  NhaCungCapEventAdd({
    required this.tenNCC,
    required this.diaChi,
    required this.sdt,
  });
}

class NhaCungCapEventUpdate extends NhaCungCapEvent {
  final String maNCC;
  final String tenNCC;
  final String diaChi;
  final String sdt;

  NhaCungCapEventUpdate({
    required this.maNCC,
    required this.tenNCC,
    required this.diaChi,
    required this.sdt,
  });
}

class NhaCungCapEventDelete extends NhaCungCapEvent {
  final String maNCC;

  NhaCungCapEventDelete({
    required this.maNCC,
  });
}
