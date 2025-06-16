class LoaiDichVuEvent {}

class LoaiDichVuEventStart extends LoaiDichVuEvent {}

class LoaiDichVuEventGetAll extends LoaiDichVuEvent {}

class LoaiDichVuEventGetById extends LoaiDichVuEvent {
  final String maLoaiDV;

  LoaiDichVuEventGetById(this.maLoaiDV);
}

class LoaiDichVuEventAdd extends LoaiDichVuEvent {
  final String tenLoaiDV;
  final double donGia;
  final double traTruoc;

  LoaiDichVuEventAdd({required this.tenLoaiDV, required this.donGia, required this.traTruoc});
}

class LoaiDichVuEventUpdate extends LoaiDichVuEvent {
  final String maLoaiDV;
  final String tenLoaiDV;
  final double donGia;
  final double traTruoc;

  LoaiDichVuEventUpdate({
    required this.maLoaiDV,
    required this.tenLoaiDV,
  required this.donGia,
  required this.traTruoc,
  });
}

class LoaiDichVuEventDelete extends LoaiDichVuEvent {
  final String maLoaiDV;

  LoaiDichVuEventDelete({required this.maLoaiDV});
}

class LoaiDichVuEventGetByName extends LoaiDichVuEvent {
  final String tenLoaiDV;

  LoaiDichVuEventGetByName(this.tenLoaiDV);
}
