import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_api.dart';

class PhieuMuaHangRepository {
  final PhieuMuaHangApi phieuMuaHangApi;

  PhieuMuaHangRepository(this.phieuMuaHangApi);

  Future<List<PhieuMuaHang>> getAll() async {
    try {
      return await phieuMuaHangApi.getAll();
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> create(String maNCC, List<Map<String, dynamic>> sanPhamMua) async {
    await phieuMuaHangApi.create(maNCC, sanPhamMua);
  }

  Future<void> delete(String maPhieu) async {
    try {
      await phieuMuaHangApi.delete(maPhieu);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }
}