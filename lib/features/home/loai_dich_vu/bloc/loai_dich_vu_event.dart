import 'package:gemstore_frontend/models/loai_dich_vu.dart';

class LoaiDichVuEvent {}

class LoaiDichVuEventStart extends LoaiDichVuEvent {}

class LoaiDichVuEventGetAll extends LoaiDichVuEvent {}

class LoaiDichVuEventCreate extends LoaiDichVuEvent {
  final String tenLDV;
  final int donGia;
  final double traTruoc;

  LoaiDichVuEventCreate({
    required this.tenLDV,
    required this.donGia,
    required this.traTruoc,
  });
}

class LoaiDichVuEventUpdate extends LoaiDichVuEvent {
  final LoaiDichVu loaiDichVu;

  LoaiDichVuEventUpdate({required this.loaiDichVu});
}

class LoaiDichVuEventDelete extends LoaiDichVuEvent {
  final String maLDV;

  LoaiDichVuEventDelete({required this.maLDV});
}