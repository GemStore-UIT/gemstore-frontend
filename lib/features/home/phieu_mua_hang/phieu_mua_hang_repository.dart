import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_api.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuMuaHangRepository {
  final PhieuMuaHangApi phieuMuaHangApi;

  PhieuMuaHangRepository(this.phieuMuaHangApi);

  Future<List<PhieuMuaHang>> getAll() async {
    return await phieuMuaHangApi.getAll();
  }

  Future<void> create(String maNCC, String ngayLap, double thanhTien, List<Map<String, dynamic>> sanPhamMua) async {
    await phieuMuaHangApi.create(maNCC, ngayLap, thanhTien, sanPhamMua);
  }

  Future<PhieuMuaHang> getById(String maPhieu) async {
    return await phieuMuaHangApi.getById(maPhieu);
  }

  List<TableRowData> convertToTableRowData(List<PhieuMuaHang> data) {
    return data.map((phieu) {
      return TableRowData(
        id: phieu.soPhieuMH,
        data: {
          'maNCC': phieu.maNCC,
          'ngayLap': phieu.ngayLap,
          'tongTien': phieu.tongTien.toString(),
        },
      );
    }).toList();
  }
}