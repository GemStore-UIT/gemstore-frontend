import 'package:dio/dio.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham.dart';

class LoaiSanPhamApi {
  final Dio dio;

  LoaiSanPhamApi(this.dio);

  Future<List<LoaiSanPham>> getAll() async {
    try {
      final response = await dio.get('/api/loaisanpham');
      if (response.statusCode == 200) {
        return LoaiSanPham.fromJsonList(response.data);

      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
