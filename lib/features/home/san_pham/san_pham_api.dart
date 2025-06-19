import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/san_pham.dart';

class SanPhamApi {
  final Dio dio;

  SanPhamApi(this.dio);

  Future<List<SanPham>> getAllSanPham() async {
    try {
      final response = await dio.get('/api/sanpham');
      return SanPham.fromJsonList(response.data);
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
      await dio.post(
        '/api/sanpham',
        data: {
          'tenSanPham': tenSanPham,
          'loaiSanPham': loaiSanPham,
          'donGia': donGia,
          'tonKho': tonKho,
        },
      );
    } catch (e) {
      throw Exception('API failed to create product: $e');
    }
  }

  Future<void> update(SanPham sanPham) async {
    try {
      await dio.post(
        '/api/sanpham',
        data: sanPham.toJson(),
      );
    } catch (e) {
      throw Exception('API failed to update product: $e');
    }
  }

  Future<void> delete(String maSP) async {
    try {
      final response = await dio.delete(
        '/api/sanpham/$maSP',
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 409) {
        throw Exception(
          'Không thể xóa sản phẩm này vì nó đang được sử dụng.',
        );
      } else if (response.statusCode != 200) {
        throw Exception('Xóa thất bại với mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API delete failed: $e');
    }
  }
}
