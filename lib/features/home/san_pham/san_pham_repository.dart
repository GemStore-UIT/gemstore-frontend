import 'package:gemstore_frontend/features/home/san_pham/san_pham.dart';
import 'package:gemstore_frontend/features/home/san_pham/san_pham_api.dart';

class SanPhamRepository {
  final SanPhamApi sanPhamApi;

  SanPhamRepository({required this.sanPhamApi});

  Future<List<SanPham>> getAllSanPham() async {
    try {
      return await sanPhamApi.getAllSanPham();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}