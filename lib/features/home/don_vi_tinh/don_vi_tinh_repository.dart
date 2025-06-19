import 'package:gemstore_frontend/models/don_vi_tinh.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_api.dart';

class DonViTinhRepository {
  final DonViTinhApi donViTinhApi;

  DonViTinhRepository(this.donViTinhApi);

  Future<List<DonViTinh>> getAll() async {
    try {
      return await donViTinhApi.getAll();
    } catch (e) {
      throw Exception('Failed to load đơn vị tính: $e');
    }
  }

  Future<void> create(String tenDonVi) async {
    try {
      await donViTinhApi.create(tenDonVi);
    } catch (e) {
      throw Exception('Repository create failed: $e');
    }
  }

  Future<void> update(String maDonVi, String tenDonVi) async {
    try {
      await donViTinhApi.update(maDonVi, tenDonVi);
    } catch (e) {
      throw Exception('Repository update failed: $e');
    }
  }

  Future<void> delete(String maDonVi) async {
    try {
      await donViTinhApi.delete(maDonVi);
    } catch (e) {
      throw Exception('Repository delete failed: $e');
    }
  }
}
