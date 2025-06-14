import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_api.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class DonViTinhRepository {
  final DonViTinhApi donViTinhApi;

  DonViTinhRepository(this.donViTinhApi);

  List<TableRowData> convertToTableRowData(List<DonViTinh> data) {
    return data.map((dvt) {
      return  TableRowData(
        id: dvt.maDonVi,
        data: {
          'name': dvt.tenDonVi,
        },
      );
    }).toList();
  }

  Future<List<DonViTinh>> getAll() async {
    try {
      return await donViTinhApi.getAll();
    } catch (e) {
      throw Exception('Failed to load đơn vị tính: $e');
    }
  }
}
