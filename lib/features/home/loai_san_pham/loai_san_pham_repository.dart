import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham_api.dart';
import 'package:gemstore_frontend/models/loai_san_pham.dart';

class LoaiSanPhamRepository {
  final LoaiSanPhamApi loaiSanPhamApi;

  LoaiSanPhamRepository(this.loaiSanPhamApi);

  Future<List<LoaiSanPham>> getAll() async {
    try {
      return await loaiSanPhamApi.getAll();
    } catch (e) {
      throw Exception('Failed to load loại sản phẩm: $e');
    }
  }

  Future<void> create(String tenLSP, Map<String, dynamic> donViTinh, double loiNhuan) async {
    try {
      await loaiSanPhamApi.create(tenLSP, donViTinh, loiNhuan);
    } catch (e) {
      throw Exception('Repository create failed: $e');
    }
  }

  Future<void> update(LoaiSanPham loaiSanPham) async {
    try {
      await loaiSanPhamApi.update(loaiSanPham);
    } catch (e) {
      throw Exception('Repository update failed: $e');
    }
  }

  Future<void> delete(String maLSP) async {
    try {
      await loaiSanPhamApi.delete(maLSP);
    } catch (e) {
      throw Exception('Repository delete failed: $e');
    }
  }
}