import 'package:gemstore_frontend/config/money_format.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_api.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuMuaHangRepository {
  final PhieuMuaHangApi phieuMuaHangApi;

  PhieuMuaHangRepository(this.phieuMuaHangApi);

  Future<List<PhieuMuaHang>> getAll() async {
    try {
      return await phieuMuaHangApi.getAll();
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> create(String maNCC, List<Map<String, dynamic>> sanPhamMua) async {
    await phieuMuaHangApi.create(maNCC, sanPhamMua);
  }

  Future<PhieuMuaHang> getById(String maPhieu) async {
    return await phieuMuaHangApi.getById(maPhieu);
  }

  Future<List<Map<String, dynamic>>> getListSanPham() async {
    try {
      return await phieuMuaHangApi.getListSanPham();
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getListNhaCungCap() async {
    try {
      return await phieuMuaHangApi.getListNhaCungCap();
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  Future<void> delete(String maPhieu) async {
    try {
      await phieuMuaHangApi.delete(maPhieu);
    } catch (e) {
      throw Exception('Repository Error: $e');
    }
  }

  List<TableRowData> convertToTableRowData(List<PhieuMuaHang> data) {
    return data.map((phieu) {
      return TableRowData(
        id: phieu.soPhieuMH,
        data: {
          'name': phieu.tenNhaCungCap,
          'date': phieu.ngayLap,
          'total': MoneyFormat.format(phieu.tongTien),
        },
      );
    }).toList();
  }
}