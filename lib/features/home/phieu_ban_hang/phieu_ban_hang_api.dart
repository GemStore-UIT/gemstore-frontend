import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/phieu_ban_hang.dart';

class PhieuBanHangApi {
  final Dio dio;

  PhieuBanHangApi(this.dio);

  Future<List<PhieuBanHang>> getAll() async {
    try {
      final response = await dio.get('/api/phieubanhang');
      return (response.data as List)
          .map((item) => PhieuBanHang.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('API Error for getAll: $e');
    }
  }

  Future<Response> create(
    String khachHang,
    List<Map<String, dynamic>> sanPhamBan,
  ) async {
    try {
      final response = await dio.post(
        '/api/phieubanhang/full',
        data: {'khachHang': khachHang, 'chiTiet': sanPhamBan},
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create phieu ban hang: $e');
    }
  }

  Future<void> delete(String soPhieu) async {
    try {
      await dio.delete('/api/phieubanhang/$soPhieu');
    } catch (e) {
      throw Exception('Failed to delete phieu ban hang: $e');
    }
  }

  Future<void> update(
    String soPhieuBH,
    String khachHang,
    List<Map<String, dynamic>> sanPhamBan,
  ) async {
    try {
      // Log the updated data for debugging
      print('Updating PhieuBanHang with soPhieuBH: $soPhieuBH, khachHang: $khachHang, sanPhamBan: $sanPhamBan');

      await dio.post(
        '/api/phieubanhang/full',
        data: {
          'soPhieuBH': soPhieuBH,
          'khachHang': khachHang,
          'chiTiet': sanPhamBan,
        },
      );
    } catch (e) {
      throw Exception('Failed to update phieu ban hang: $e');
    }
  }
}
