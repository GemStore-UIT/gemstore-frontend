import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/loai_san_pham.dart';

class LoaiSanPhamApi {
  final Dio dio;

  LoaiSanPhamApi(this.dio);

  Future<List<LoaiSanPham>> getAll() async {
    try {
      final response = await dio.get('/api/loaisanpham');
      return LoaiSanPham.fromJsonList(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> create(String tenLSP, Map<String, dynamic> donViTinh, double loiNhuan) async {
    try {
      await dio.post('/api/loaisanpham', data: {
        'tenLSP': tenLSP,
        'donViTinh': donViTinh,
        'loiNhuan': loiNhuan,
      });
    } catch (e) {
      throw Exception('API create failed: $e');
    }
  }

  Future<void> update(LoaiSanPham loaiSanPham) async {
    try {
      await dio.post(
        '/api/loaisanpham',
        data: loaiSanPham.toJson(),
      );
    } catch (e) {
      throw Exception('API update failed: $e');
    }
  }

  Future<void> delete(String maLSP) async {
    try {
      final response = await dio.delete(
        '/api/loaisanpham/$maLSP',
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 409) {
        throw Exception(
          'Không thể xóa loại sản phẩm này vì nó đang được sử dụng.',
        );
      } else if (response.statusCode != 200) {
        throw Exception('Xóa thất bại với mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API delete failed: $e');
    }
  }
}
