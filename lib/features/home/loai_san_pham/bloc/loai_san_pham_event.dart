class LoaiSanPhamEvent {}

class LoaiSanPhamEventStart extends LoaiSanPhamEvent {}

class LoaiSanPhamEventGetAll extends LoaiSanPhamEvent {}

class LoaiSanPhamEventGetById extends LoaiSanPhamEvent {
  final String maLoaiSP;

  LoaiSanPhamEventGetById(this.maLoaiSP);
}

class LoaiSanPhamEventAdd extends LoaiSanPhamEvent {
  final String tenLoaiSP;

  LoaiSanPhamEventAdd({
    required this.tenLoaiSP,
  });
}

class LoaiSanPhamEventUpdate extends LoaiSanPhamEvent {
  final String maLoaiSP;
  final String tenLoaiSP;
  final String donViTinh;
  final double  loiNhuan;

  LoaiSanPhamEventUpdate({
    required this.maLoaiSP,
    required this.tenLoaiSP,
    required this.donViTinh,
    required this.loiNhuan,
  });
}

class LoaiSanPhamEventDelete extends LoaiSanPhamEvent {
  final String maLoaiSP;

  LoaiSanPhamEventDelete({
    required this.maLoaiSP,
  });
}



