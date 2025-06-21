import 'package:gemstore_frontend/features/report/bao_cao_api.dart';
import 'package:gemstore_frontend/screens/home/view_list/bao_cao_screen.dart';

class BaoCaoRepository {
  final BaoCaoApi baoCaoApi;

  BaoCaoRepository(this.baoCaoApi);

  Future<List<ProductData>> getBaoCao(int thang, int nam) async {
    return await baoCaoApi.getBaoCao(thang, nam);
  }
}