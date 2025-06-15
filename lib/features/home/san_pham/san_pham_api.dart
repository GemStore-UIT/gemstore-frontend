import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/san_pham/san_pham.dart';

class SanPhamApi {
  final Dio dio;

  SanPhamApi({required this.dio});

  Future<List<SanPham>> getAllSanPham() async {
    try {
      final response = await dio.get('/api/sanpham');
      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((item) => SanPham.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }
}
