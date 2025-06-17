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
}
