import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/data/nha_cung_cap_repository.dart';

class NhaCungCapApiClient {
  final Dio dio;

  NhaCungCapApiClient(this.dio);

  Future<List<NhaCungCapModel>> getAllNhaCungCap() async {
    try {
      final response = await dio.get('/NHACUNGCAP');
      if (response.statusCode == 200) {
        return (List<NhaCungCapModel>.from(
          response.data.map((item) => NhaCungCapModel.fromJson(item)),
        ));
      } else {
        throw Exception('Failed to load suppliers');
      }
    } catch (e) {
      throw Exception('Failed to load suppliers: $e');
    }
  }
}