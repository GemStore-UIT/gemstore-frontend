import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/nha_cung_cap.dart';

class NhaCungCapApi {
  final Dio dio;

  NhaCungCapApi(this.dio);

  Future<List<NhaCungCap>> getAll() async {
    try {
      final response = await dio.get('/api/nhacungcap');
        return NhaCungCap.fromJsonList(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> create(String tenNCC, String diaChi, String sdt) async {
    try {
      await dio.post('/api/nhacungcap', data: {
        'tenNCC': tenNCC,
        'diaChi': diaChi,
        'sdt': sdt,
      });
    } catch (e) {
      throw Exception('API create failed: $e');
    }
  }

  Future<void> update(NhaCungCap nhacungcap) async {
    try {
      await dio.post(
        '/api/nhacungcap',
        data: nhacungcap.toJson(),
      );
    } catch (e) {
      throw Exception('API update failed: $e');
    }
  }

  Future<void> delete(String maNCC) async {
    try {
      final response = await dio.delete(
        '/api/nhacungcap/$maNCC',
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 409) {
        throw Exception(
          'Không thể xóa nhà cung cấp này vì nó đang được sử dụng.',
        );
      } else if (response.statusCode != 200) {
        throw Exception('Xóa thất bại với mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API delete failed: $e');
    }
  }
}
