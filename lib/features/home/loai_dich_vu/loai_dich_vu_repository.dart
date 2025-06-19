import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu_api.dart';
import 'package:gemstore_frontend/models/loai_dich_vu.dart';

class LoaiDichVuRepository {
  final LoaiDichVuApi loaiDichVuApi;

  LoaiDichVuRepository(this.loaiDichVuApi);

  Future<List<LoaiDichVu>> getAll() async {
    try {
      return await loaiDichVuApi.getAll();
    } catch (e) {
      throw Exception('Failed to load loại dịch vụ: $e');
    }
  }

  Future<void> create(String tenLDV, int donGia, double traTruoc) async {
    try {
      await loaiDichVuApi.create(tenLDV, donGia, traTruoc);
    } catch (e) {
      throw Exception('Repository create failed: $e');
    }
  }

  Future<void> update(LoaiDichVu loaiDichVu) async {
    try {
      await loaiDichVuApi.update(loaiDichVu);
    } catch (e) {
      throw Exception('Repository update failed: $e');
    }
  }

  Future<void> delete(String maLDV) async {
    try {
      await loaiDichVuApi.delete(maLDV);
    } catch (e) {
      throw Exception('Repository delete failed: $e');
    }
  }  
}