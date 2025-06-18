import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/don_vi_tinh.dart';

class DonViTinhApi {
  final Dio dio;

  DonViTinhApi(this.dio);

  Future<List<DonViTinh>> getAll() async {
    try {
      final response = await dio.get('/api/donvitinh');
      return DonViTinh.fromJsonList(response.data);
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> create(String tenDonVi) async {
    try {
      await dio.post('/api/donvitinh', data: {'tenDonVi': tenDonVi});
    } catch (e) {
      throw Exception('API create failed: $e');
    }
  }

  Future<void> update(String maDonVi, String tenDonVi) async {
    try {
      await dio.post(
        '/api/donvitinh',
        data: {'maDonVi': maDonVi, 'tenDonVi': tenDonVi},
      );
    } catch (e) {
      throw Exception('API update failed: $e');
    }
  }

  Future<void> delete(String maDonVi) async {
    try {
      final response = await dio.delete(
        '/api/donvitinh/$maDonVi',
        options: Options(validateStatus: (status) => true),
      );

      if (response.statusCode == 409) {
        throw Exception(
          'Không thể xóa đơn vị tính này vì nó đang được sử dụng.',
        );
      } else if (response.statusCode != 200) {
        throw Exception('Xóa thất bại với mã lỗi: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('API delete failed: $e');
    }
  }
}
