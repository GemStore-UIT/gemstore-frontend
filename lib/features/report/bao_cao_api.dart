import 'package:dio/dio.dart';
import 'package:gemstore_frontend/screens/home/view_list/bao_cao_screen.dart';

class BaoCaoApi {
  final Dio dio;

  BaoCaoApi(this.dio);

  Future<List<ProductData>> getBaoCao(int thang, int nam) async {
    try {
      final response = await dio.get(
        '/api/baocao/{thang}/{nam}?thang=$thang&nam=$nam',
      );
      return (response.data as List)
          .map((item) => ProductData.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Error fetching report: $e');
    }
  }
}
