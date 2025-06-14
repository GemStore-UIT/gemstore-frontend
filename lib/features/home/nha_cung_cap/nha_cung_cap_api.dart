import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap.dart';

class NhaCungCapApi {
  final Dio dio;

  NhaCungCapApi(this.dio);

  Future<List<NhaCungCap>> getAll() async {
    try {
      final response = await dio.get('/api/nhacungcap');
      if (response.statusCode == 200) {
        return NhaCungCap.fromJsonList(response.data);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
