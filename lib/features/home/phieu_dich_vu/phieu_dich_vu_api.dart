import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/phieu_dich_vu.dart';

class PhieuDichVuApi {
  final Dio dio;

  PhieuDichVuApi(this.dio);

  Future<List<PhieuDichVu>> getAll() async {
    try {
      final response = await dio.get('/api/phieudichvu');
      return (response.data as List)
          .map((item) => PhieuDichVu.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('API Error for getAll: $e');
    }
  }

  Future<Response> create(
    String khachHang,
    String sdt,
    List<Map<String, dynamic>> chiTiet,
  ) async {
    try {
      final response = await dio.post(
        '/api/phieudichvu/full',
        data: {'khachHang': khachHang, 'sdt': sdt, 'chiTiet': chiTiet},
      );
      return response;
    } catch (e) {
      throw Exception('API Error for create: $e');
    }
  }

  Future<void> delete(String soPhieuDV) async {
    try {
      await dio.delete('/api/phieudichvu/$soPhieuDV');
    } catch (e) {
      throw Exception('API Error for delete: $e');
    }
  }

  Future<void> update(
    String soPhieuDV,
    String khachHang,
    String sdt,
    List<Map<String, dynamic>> chiTiet,
  ) async {
    try {
      // Log the parameters for debugging
      print(
        'soPhieuDV:$soPhieuDV, khachHang:$khachHang, sdt:$sdt, chiTiet:$chiTiet',
      );

      await dio.post(
        '/api/phieudichvu/full',
        data: {
          'soPhieuDV': soPhieuDV,
          'khachHang': khachHang,
          'sdt': sdt,
          'chiTiet': chiTiet,
        },
      );
    } catch (e) {
      throw Exception('API Error for update: $e');
    }
  }
}
