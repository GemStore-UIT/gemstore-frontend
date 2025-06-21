import 'package:dio/dio.dart';
import 'package:gemstore_frontend/models/tham_so.dart';

class ThamSoApi {
  final Dio dio;

  ThamSoApi(this.dio);

  Future<List<ThamSo>> getAll() async {
    try {
      final response = await dio.get('/api/thamso');
      return ThamSo.fromJsonList(response.data);
    } catch (e) {
      throw Exception('Error fetching tham so: $e');
    }
  }

  Future<void> updateThamSo(String tenThamSo, String giaTri) async {
    try {
      await dio.post('/api/thamso', data: {
        'tenThamSo': tenThamSo,
        'giaTri': giaTri,
      });
    } catch (e) {
      throw Exception('Error updating tham so: $e');
    }
  }
}
