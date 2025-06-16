import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham_api.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class LoaiSanPhamRepository {
  LoaiSanPhamApi loaiSanPhamApi;

  LoaiSanPhamRepository(this.loaiSanPhamApi);

  List<TableRowData> convertToTableRowData(List<LoaiSanPham> data) {
    return data.map((lsp) {
      return TableRowData(
        id: lsp.maLSP,
        data: {
          'name': lsp.tenLSP,
          'unit': lsp.donViTinh.tenDonVi,
          'profit': lsp.loiNhuan,
        },
      );
    }).toList();
  }

  Future<List<LoaiSanPham>> getAll() async {
    try {
      return await loaiSanPhamApi.getAll();
    } catch (e) {
      throw Exception('Failed to load loại sản phẩm: $e');
    }
  }
}
