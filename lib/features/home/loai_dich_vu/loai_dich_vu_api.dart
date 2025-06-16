import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu.dart';


class LoaiDichVuApi {
  final Dio dio;

  LoaiDichVuApi(this.dio);

  Future<List<LoaiDichVu>> getAll() async {
    try {
      final response = await dio.get('/api/loaidichvu');
      if (response.statusCode == 200) {
        return LoaiDichVu.fromJsonList(response.data);
      } else {
        throw Exception("Error ${response.statusCode}");
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
