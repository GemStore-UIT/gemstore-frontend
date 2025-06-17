import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/san_pham.dart';

class SanPhamApi {
  final Dio dio;

  SanPhamApi(this.dio);

  Future<List<SanPham>> getAllSanPham() async {
    try {
      final response = await dio.get('/api/sanpham');
      if (response.statusCode == 200) {
        return SanPham.fromJsonList(response.data);
      } else {
        throw Exception('API failed to load products');
      }
    } catch (e) {
      throw Exception('API failed to load products: $e');
    }
  }

  Future<void> create({
    required String tenSanPham,
    required Map<String, dynamic> loaiSanPham,
    required int donGia,
    required int tonKho,
  }) async {
    try {
      final response = await dio.post('/api/sanpham', data: {
        'ten_san_pham': tenSanPham,
        'loai_san_pham': loaiSanPham,
        'don_gia': donGia,
        'ton_kho': tonKho,
      });
      if (response.statusCode != 201) {
        throw Exception('API failed to create product');
      }
    } catch (e) {
      throw Exception('API failed to create product: $e');
    }
  }

  Future<void> delete(String maSanPham) async {
    try {
      final response = await dio.delete('/api/sanpham/$maSanPham');
      if (response.statusCode != 204) {
        throw Exception('API failed to delete product');
      }
    } catch (e) {
      throw Exception('API failed to delete product: $e');
    }
  }

  Future<void> update(SanPham sanPham) async {
    try {
      final response = await dio.put('/api/sanpham/${sanPham.maSanPham}', data: sanPham.toJson());
      if (response.statusCode != 200) {
        throw Exception('API failed to update product');
      }
    } catch (e) {
      throw Exception('API failed to update product: $e');
    }
  }
}
