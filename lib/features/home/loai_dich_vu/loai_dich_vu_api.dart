import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/loai_dich_vu.dart';

class LoaiDichVuApi {
  final Dio dio;

  LoaiDichVuApi(this.dio);

  Future<List<LoaiDichVu>> getAll() async {
    try {
      final response = await dio.get('/api/loaidichvu');
      return LoaiDichVu.fromJsonList(response.data);
    } catch (e) {
      throw Exception('API getAll failed: $e');
    }
  }

  Future<void> create(String tenLDV, int donGia, double traTruoc) async {
    try {
      await dio.post(
        '/api/loaidichvu',
        data: {'tenLDV': tenLDV, 'donGia': donGia, 'traTruoc': traTruoc},
      );
    } catch (e) {
      throw Exception('API create failed: $e');
    }
  }

  Future<void> update(LoaiDichVu loaiDichVu) async {
    try {
      await dio.post('/api/loaidichvu', data: loaiDichVu.toJson());
    } catch (e) {
      throw Exception('API update failed: $e');
    }
  }

  Future<void> delete(String maLDV) async {
    try {
      final response = await dio.delete(
        '/api/loaidichvu/$maLDV',
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 409) {
        throw Exception(
          'Không thể xóa loại dịch vụ này vì nó đang được sử dụng.',
        );
      } else if (response.statusCode != 200) {
        throw Exception('Xóa thất bại với mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API delete failed: $e');
    }
  }
}
