import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

sealed class PhieuMuaHangState {}

class PhieuMuaHangStateInitial extends PhieuMuaHangState {}

class PhieuMuaHangStateLoading extends PhieuMuaHangState {}

class PhieuMuaHangStateSuccess extends PhieuMuaHangState {
  final List<TableRowData> phieuMuaHangs;
  final List<Map<String, dynamic>> listSanPham;
  /*
  [
    {
      "maSanPham": "SP001",
      "tenSanPham": "Sản phẩm 1",
      "loaiSanPham": "Loại 1",
      "donViTinh": "Cái",
      "donGia": 10000
    },
    {
      "maSanPham": "SP002",
      "tenSanPham": "Sản phẩm 2",
      "loaiSanPham": "Loại 2",
      "donViTinh": "Cái",
      "donGia": 20000
    }
  ]
  */
  PhieuMuaHangStateSuccess(this.phieuMuaHangs, this.listSanPham);
}

class PhieuMuaHangStateFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateFailure(this.error);
}

class PhieuMuaHangStateGetDetailSuccess extends PhieuMuaHangState {
  final PhieuMuaHang phieuMuaHang;

  PhieuMuaHangStateGetDetailSuccess(this.phieuMuaHang);
}

class PhieuMuaHangStateGetDetailFailure extends PhieuMuaHangState {
  final String error;

  PhieuMuaHangStateGetDetailFailure(this.error);
}
