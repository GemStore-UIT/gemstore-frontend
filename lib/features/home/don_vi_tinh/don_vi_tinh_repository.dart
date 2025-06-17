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
}
