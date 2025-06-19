import 'package:gemstore_frontend/models/nha_cung_cap.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_api.dart';

class NhaCungCapRepository {
  final NhaCungCapApi nhaCungCapApi;

  NhaCungCapRepository(this.nhaCungCapApi);

  Future<List<NhaCungCap>> getAll() async {
    try {
      return await nhaCungCapApi.getAll();
    } catch (e) {
      throw Exception('Failed to load nhà cung cấp: $e');
    }
  }

  Future<void> create(String tenNCC, String diaChi, String sdt) async {
    try {
      await nhaCungCapApi.create(tenNCC, diaChi, sdt);
    } catch (e) {
      throw Exception('Repository create failed: $e');
    }
  }

  Future<void> update(NhaCungCap nhaCungCap) async {
    try {
      await nhaCungCapApi.update(nhaCungCap);
    } catch (e) {
      throw Exception('Repository update failed: $e');
    }
  }

  Future<void> delete(String maNCC) async {
    try {
      await nhaCungCapApi.delete(maNCC);
    } catch (e) {
      throw Exception('Repository delete failed: $e');
    }
  }
}
