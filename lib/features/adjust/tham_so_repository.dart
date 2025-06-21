import 'package:gemstore_frontend/features/adjust/tham_so_api.dart';
import 'package:gemstore_frontend/models/tham_so.dart';

class ThamSoRepository {
  final ThamSoApi thamSoApi;

  ThamSoRepository(this.thamSoApi);

  Future<List<ThamSo>> getAll() async {
    try {
      return await thamSoApi.getAll();
    } catch (e) {
      throw Exception('Error fetching tham so: $e');
    }
  }

  Future<void> updateThamSo(String tenThamSo, String giaTri) async {
    try {
      await thamSoApi.updateThamSo(tenThamSo, giaTri);
    } catch (e) {
      throw Exception('Error updating tham so: $e');
    }
  }
}