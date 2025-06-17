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

  Future<PhieuMuaHang> getById(String maPhieu) async {
    try {
      final response = await dio.get('/api/phieumuahang/$maPhieu');
      return PhieuMuaHang.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to load phieu mua hang by id: $e');
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

  Future<List<Map<String, dynamic>>> getListSanPham() async {
    try {
      final response = await dio.get('/api/sanpham');
      if (response.statusCode == 200) {
        return (response.data as List).map((item) {
          final mapItem = item as Map<String, dynamic>;
          return {
            'maSanPham': mapItem['maSanPham'],
            'tenSanPham': mapItem['tenSanPham'],
            'loaiSanPham': mapItem['loaiSanPham']['tenLSP'],
            'donViTinh': mapItem['loaiSanPham']['donViTinh']['tenDonVi'],
            'donGia': mapItem['donGia'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('API Error for getListSanPham: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getListNhaCungCap() async {
    try {
      final response = await dio.get('/api/nhacungcap');
      if (response.statusCode == 200) {
        return (response.data as List).map((item) {
          final mapItem = item as Map<String, dynamic>;
          return {
            'maNhaCungCap': mapItem['maNCC'],
            'tenNhaCungCap': mapItem['tenNCC'],
            'diaChi': mapItem['diaChi'],
            'soDienThoai': mapItem['sdt'],
          };
        }).toList();
      } else {
        throw Exception('Failed to load suppliers');
      }
    } catch (e) {
      throw Exception('API Error for getListNhaCungCap: $e');
    }
  }

  Future<void> delete(String maPhieu) async {
    try {
      await dio.delete('/api/phieumuahang/$maPhieu');
    } catch (e) {
      throw Exception('Failed to delete phieu mua hang: $e');
    }
  }
}
