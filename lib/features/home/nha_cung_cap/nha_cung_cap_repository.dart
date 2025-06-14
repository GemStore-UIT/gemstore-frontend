import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_api.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class NhaCungCapRepository {
  final NhaCungCapApi nhaCungCapApi;

  NhaCungCapRepository(this.nhaCungCapApi);

  List<TableRowData> convertToTableRowData(List<NhaCungCap> data) {
    return data.map((ncc) {
      return  TableRowData(
        id: ncc.maNCC,
        data: {
          'name': ncc.tenNCC,
          'address': ncc.diaChi,
          'phone': ncc.sdt,
        },
      );
    }).toList();
  }

  Future<List<NhaCungCap>> getAll() async {
    try {
      return await nhaCungCapApi.getAll();
    } catch (e) {
      throw Exception('Failed to load nhà cung cấp: $e');
    }
  }
}