import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';

class PhieuMuaHangApi {
  final Dio dio;

  PhieuMuaHangApi(this.dio);

  Future<List<PhieuMuaHang>> getAll() async {
    try {
      final response = await dio.get('/api/phieumuahang');
      return (response.data as List)
          .map((item) => PhieuMuaHang.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('API Error for getAll: $e');
    }
  }

  Future<Response> create(
    String maNCC,
    List<Map<String, dynamic>> sanPhamMua,
  ) async {
    try {
      final response = await dio.post(
        '/api/phieumuahang/full',
        data: {
          'nhaCungCap': maNCC,
          'chiTiet': sanPhamMua,
        },
      );
      return response;
    } catch (e) {
      throw Exception('Failed to create phieu mua hang: $e');
    }
  }

  Future<void> delete(String maPhieu) async {
    try {
      await dio.delete('/api/phieumuahang/$maPhieu');
    } catch (e) {
      throw Exception('Failed to delete phieu mua hang: $e');
    }
  }

  Future<void> update(PhieuMuaHangUpdateDto updatedData) async {
    try {
      await dio.post(
        '/api/phieumuahang/full',
        data: updatedData.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to update phieu mua hang: $e');
    }
  }
}
