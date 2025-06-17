import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuMuaHang {
  String soPhieuMH;
  String ngayLap;
  String tenNhaCungCap;
  int tongTien;
  List<SanPhamMua> chiTiet;

  PhieuMuaHang({
    required this.soPhieuMH,
    required this.ngayLap,
    required this.tenNhaCungCap,
    required this.tongTien,
    required this.chiTiet,
  });

  factory PhieuMuaHang.fromJson(Map<String, dynamic> json) {
    return PhieuMuaHang(
      soPhieuMH: json['soPhieuMH'],
      ngayLap: json['ngayLap'],
      tenNhaCungCap: json['tenNhaCungCap'],
      tongTien: json['tongTien'],
      chiTiet: (json['chiTiet'] as List)
          .map((item) => SanPhamMua.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soPhieuMH': soPhieuMH,
      'ngayLap': ngayLap,
      'tenNhaCungCap': tenNhaCungCap,
      'tongTien': tongTien,
      'chiTiet': chiTiet.map((item) => item.toJson()).toList(),
    };
  }

  static List<PhieuMuaHang> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((json) => PhieuMuaHang.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  static List<TableRowData> convertToTableRowData(List<PhieuMuaHang> data) {
    return data.map((phieu) {
      return TableRowData(
        id: phieu.soPhieuMH,
        data: {
          'name': phieu.tenNhaCungCap,
          'date': phieu.ngayLap,
          'total': phieu.tongTien,
        },
      );
    }).toList();
  }
}

class SanPhamMua {
  String maSanPham;
  String tenSanPham;
  int soLuong;
  int thanhTien;

  SanPhamMua({
    required this.maSanPham,
    required this.tenSanPham,
    required this.soLuong,
    required this.thanhTien,
  });

  factory SanPhamMua.fromJson(Map<String, dynamic> json) {
    return SanPhamMua(
      maSanPham: json['maSanPham'],
      tenSanPham: json['tenSanPham'],
      soLuong: json['soLuong'],
      thanhTien: json['thanhTien'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSanPham': maSanPham,
      'tenSanPham': tenSanPham,
      'soLuong': soLuong,
      'thanhTien': thanhTien,
    };
  }
}
