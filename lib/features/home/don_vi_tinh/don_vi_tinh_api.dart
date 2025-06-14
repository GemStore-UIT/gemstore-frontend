import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh.dart';

class DonViTinhApi {
  final Dio dio;

  DonViTinhApi(this.dio);

//call API
  Future<List<DonViTinh>> getAll() async {
    try {
      final response = await dio.get('/api/donvitinh');
      if (response.statusCode == 200) {
        return DonViTinh.fromJsonList(response.data);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
