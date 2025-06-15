import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang.dart';

class PhieuMuaHangApi {
  final Dio dio;

  PhieuMuaHangApi(this.dio);

  Future<List<PhieuMuaHang>> getAll() async {
    try {
      final response = await dio.get('/phieumuahang');
      return (response.data as List)
          .map((item) => PhieuMuaHang.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to load phieu mua hang: $e');
    }
  }

  Future<PhieuMuaHang> getById(String maPhieu) async {
    try {
      final response = await dio.get('/phieumuahang/$maPhieu');
      return PhieuMuaHang.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load phieu mua hang by id: $e');
    }
  }

  Future<Response> create(String maNCC, String ngayLap, double thanhTien, List<Map<String, dynamic>> sanPhamMua) async {
    try {
      final response = await dio.post('/phieumuahang', data:  {
        'maNCC': maNCC,
        'ngayLap': ngayLap,
        'thanhTien': thanhTien,
        'sanPhamMua': sanPhamMua,
      });
      return response;
    } catch (e) {
      throw Exception('Failed to create phieu mua hang: $e');
    }
  }
  
}
