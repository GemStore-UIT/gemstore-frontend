import 'package:gemstore_frontend/features/home/phieu_ban_hang/phieu_ban_hang_api.dart';
import 'package:gemstore_frontend/models/phieu_ban_hang.dart';

class PhieuBanHangRepository {
  final PhieuBanHangApi phieuBanHangApi;

  PhieuBanHangRepository(this.phieuBanHangApi);

  Future<List<PhieuBanHang>> getAll() async {
    try {
      return await phieuBanHangApi.getAll();
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> create(String khachHang, List<Map<String, dynamic>> sanPhamBan) async {
    await phieuBanHangApi.create(khachHang, sanPhamBan);
  }

  Future<void> update(
    String soPhieuBH,
    String khachHang,
    List<Map<String, dynamic>> sanPhamBan,
  ) async {
    try {
      await phieuBanHangApi.update(soPhieuBH, khachHang, sanPhamBan);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> delete(String soPhieu) async {
    try {
      await phieuBanHangApi.delete(soPhieu);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }
}
