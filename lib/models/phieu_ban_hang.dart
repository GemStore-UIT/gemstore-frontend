import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuBanHang {
  String soPhieuBH;
  String ngayLap;
  String khachHang;
  int tongTien;
  List<ChiTietPhieuBanHang> chiTiet;

  PhieuBanHang({
    required this.soPhieuBH,
    required this.ngayLap,
    required this.khachHang,
    required this.tongTien,
    required this.chiTiet,
  });

  factory PhieuBanHang.fromJson(Map<String, dynamic> json) {
    return PhieuBanHang(
      soPhieuBH: json['soPhieuBH'],
      ngayLap: json['ngayLap'],
      khachHang: json['khachHang'],
      tongTien: json['tongTien'],
      chiTiet: (json['chiTiet'] as List)
          .map((item) => ChiTietPhieuBanHang.fromJson(item))
          .toList(),
    );
  }

  static List<TableRowData> convertToTableRowData(List<PhieuBanHang> phieuBanHangs) {
    return phieuBanHangs.map((phieu) {
      return TableRowData(
        id: phieu.soPhieuBH,
        data: {
          'name': phieu.khachHang,
          'date': phieu.ngayLap,
          'total': phieu.tongTien,
          'details': phieu.chiTiet.map((item) => item.toJson()).toList(),
        },
      );
    }).toList();
  }
}

class ChiTietPhieuBanHang {
  String maSanPham;
  String tenSanPham;
  int soLuong;
  int thanhTien;

  ChiTietPhieuBanHang({
    required this.maSanPham,
    required this.tenSanPham,
    required this.soLuong,
    required this.thanhTien,
  });

  factory ChiTietPhieuBanHang.fromJson(Map<String, dynamic> json) {
    return ChiTietPhieuBanHang(
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
