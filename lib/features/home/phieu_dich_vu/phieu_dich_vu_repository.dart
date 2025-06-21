import 'package:gemstore_frontend/features/home/phieu_dich_vu/phieu_dich_vu_api.dart';
import 'package:gemstore_frontend/models/phieu_dich_vu.dart';

class PhieuDichVuRepository {
  final PhieuDichVuApi phieuDichVuApi;

  PhieuDichVuRepository(this.phieuDichVuApi);

  Future<List<PhieuDichVu>> getAll() async {
    try {
      return await phieuDichVuApi.getAll();
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> update(
    String soPhieuDV,
    String khachHang,
    String sdt,
    List<Map<String, dynamic>> chiTiet,
  ) async {
    try {
      await phieuDichVuApi.update(soPhieuDV, khachHang, sdt, chiTiet);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> create(
    String khachHang,
    String sdt,
    List<Map<String, dynamic>> chiTiet,
  ) async {
    try {
      await phieuDichVuApi.create(khachHang, sdt, chiTiet);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> delete(String soPhieuDV) async {
    try {
      await phieuDichVuApi.delete(soPhieuDV);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }
}
