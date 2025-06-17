import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/features/home/san_pham/san_pham_api.dart';

class SanPhamRepository {
  final SanPhamApi sanPhamApi;

  SanPhamRepository(this.sanPhamApi);

  Future<List<SanPham>> getAllSanPham() async {
    try {
      return await sanPhamApi.getAllSanPham();
    } catch (e) {
      throw Exception('Repository failed to load products: $e');
    }
  }

  Future<void> create({
    required String tenSanPham,
    required Map<String, dynamic> loaiSanPham,
    required int donGia,
    required int tonKho,
  }) async {
    try {
      await sanPhamApi.create(
        tenSanPham: tenSanPham,
        loaiSanPham: loaiSanPham,
        donGia: donGia,
        tonKho: tonKho,
      );
    } catch (e) {
      throw Exception('Repository failed to create product: $e');
    }
  }

  Future<void> delete(String maSanPham) async {
    try {
      await sanPhamApi.delete(maSanPham);
    } catch (e) {
      throw Exception('Repository failed to delete product: $e');
    }
  }

  Future<void> update(SanPham sanPham) async {
    try {
      await sanPhamApi.update(sanPham);
    } catch (e) {
      throw Exception('Repository failed to update product: $e');
    }
  }
}