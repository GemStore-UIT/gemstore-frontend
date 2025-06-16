import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu_api.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class LoaiDichVuRepository {
  final LoaiDichVuApi loaiDichVuApi;

  LoaiDichVuRepository(this.loaiDichVuApi);

  List<TableRowData> convertToTableRowData(List<LoaiDichVu> data) {
    return data.map((ldv) {
      return  TableRowData(
        id: ldv.maLDV,
        data: {
          'name': ldv.tenLDV,
          'price': ldv.donGia,
          'prepaid': ldv.traTruoc,
        },
      );
    }).toList();
  }

 Future<List<LoaiDichVu>> getAll() async {
  try {
    return await loaiDichVuApi.getAll(); 
  } catch (e) {
    throw Exception('Failed to load loại dịch vụ: $e');
  }
}
}
