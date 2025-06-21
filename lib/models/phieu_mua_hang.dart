import 'package:gemstore_frontend/models/nha_cung_cap.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuMuaHang {
  String soPhieuMH;
  String ngayLap;
  NhaCungCap nhaCungCap;
  int tongTien;
  List<ChiTietPhieuMuaHang> chiTiet;

  PhieuMuaHang({
    required this.soPhieuMH,
    required this.ngayLap,
    required this.nhaCungCap,
    required this.tongTien,
    required this.chiTiet,
  });

  factory PhieuMuaHang.fromJson(Map<String, dynamic> json) {
    return PhieuMuaHang(
      soPhieuMH: json['soPhieuMH'],
      ngayLap: json['ngayLap'],
      nhaCungCap: NhaCungCap.fromJson(json['nhaCungCap']),
      tongTien: json['tongTien'],
      chiTiet:
          (json['chiTiet'] as List)
              .map((item) => ChiTietPhieuMuaHang.fromJson(item))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soPhieuMH': soPhieuMH,
      'ngayLap': ngayLap,
      'nhaCungCap': nhaCungCap.toJson(),
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
          'name': phieu.nhaCungCap.tenNCC,
          'date': phieu.ngayLap,
          'total': phieu.tongTien,
          'details': phieu.chiTiet.map((item) => item.toJson()).toList(),
        },
      );
    }).toList();
  }
}

class ChiTietPhieuMuaHang {
  String maSanPham;
  String tenSanPham;
  int soLuong;
  int thanhTien;

  ChiTietPhieuMuaHang({
    required this.maSanPham,
    required this.tenSanPham,
    required this.soLuong,
    required this.thanhTien,
  });

  factory ChiTietPhieuMuaHang.fromJson(Map<String, dynamic> json) {
    return ChiTietPhieuMuaHang(
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

class PhieuMuaHangUpdateDto {
  String soPhieuMH;
  String nhaCungCap;
  List<ChiTietPhieuMuaHangUpdateDto> chiTiet;

  PhieuMuaHangUpdateDto({
    required this.soPhieuMH,
    required this.nhaCungCap,
    required this.chiTiet,
  });

  Map<String, dynamic> toJson() {
    return {
      'soPhieuMH': soPhieuMH,
      'nhaCungCap': nhaCungCap,
      'chiTiet': chiTiet.map((item) => item.toJson()).toList(),
    };
  }
}

class ChiTietPhieuMuaHangUpdateDto {
  String maSanPham;
  int soLuong;

  ChiTietPhieuMuaHangUpdateDto({
    required this.maSanPham,
    required this.soLuong,
  });

  Map<String, dynamic> toJson() {
    return {'maSanPham': maSanPham, 'soLuong': soLuong};
  }

  factory ChiTietPhieuMuaHangUpdateDto.fromJson(Map<String, dynamic> json) {
    return ChiTietPhieuMuaHangUpdateDto(
      maSanPham: json['maSanPham'],
      soLuong: json['soLuong'],
    );
  }

  factory ChiTietPhieuMuaHangUpdateDto.fromJsonNotFull(
    Map<String, dynamic> json,
    List<SanPham> sanPhamList,
  ) {
    return ChiTietPhieuMuaHangUpdateDto(
      maSanPham: json['maSanPham'],
      soLuong: json['soLuong'],
    );
  }
}
