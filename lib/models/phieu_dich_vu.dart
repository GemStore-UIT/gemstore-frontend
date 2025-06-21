import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class PhieuDichVu {
  String soPhieuDV;
  String ngayLap;
  String khachHang;
  String sdt;
  int tongTien;
  int tongTienTraTruoc;
  int tongTienConLai;
  String tinhTrang;
  List<ChiTietPhieuDichVu> chiTiet;

  PhieuDichVu({
    required this.soPhieuDV,
    required this.ngayLap,
    required this.khachHang,
    required this.sdt,
    required this.tongTien,
    required this.tongTienTraTruoc,
    required this.tongTienConLai,
    required this.tinhTrang,
    required this.chiTiet,
  });

  factory PhieuDichVu.fromJson(Map<String, dynamic> json) {
    return PhieuDichVu(
      soPhieuDV: json['soPhieuDV'],
      ngayLap: json['ngayLap'],
      khachHang: json['khachHang'],
      sdt: json['sdt'],
      tongTien: json['tongTien'],
      tongTienTraTruoc: json['tongTienTraTruoc'],
      tongTienConLai: json['tongTienConLai'],
      tinhTrang: json['tinhTrang'],
      chiTiet:
          (json['chiTiet'] as List)
              .map((item) => ChiTietPhieuDichVu.fromJson(item))
              .toList(),
    );
  }

  static List<TableRowData> convertToTableRowData(List<PhieuDichVu> phieuDichVus) {
    return phieuDichVus.map((phieu) {
      return TableRowData(
        id: phieu.soPhieuDV,
        data: {
          'name': phieu.khachHang,
          'date': phieu.ngayLap,
          'phone': phieu.sdt,
          'total': phieu.tongTien,
          'totalPaid': phieu.tongTienTraTruoc,
          'totalLeft': phieu.tongTienConLai,
          'status': phieu.tinhTrang,
          'details': phieu.chiTiet.map((item) => item.toJson()).toList(),
        },
      );
    }).toList();
  }
}

class ChiTietPhieuDichVu {
  String soPhieuDV;
  String maLDV;
  String tenLDV;
  int donGia;
  int soLuong;
  int traTruoc;
  int thanhTien;
  int conLai;
  String ngayGiao;
  String tinhTrang;

  ChiTietPhieuDichVu({
    required this.soPhieuDV,
    required this.maLDV,
    required this.tenLDV,
    required this.donGia,
    required this.soLuong,
    required this.traTruoc,
    required this.thanhTien,
    required this.conLai,
    required this.ngayGiao,
    required this.tinhTrang,
  });

  factory ChiTietPhieuDichVu.fromJson(Map<String, dynamic> json) {
    return ChiTietPhieuDichVu(
      soPhieuDV: json['soPhieuDV'],
      maLDV: json['maLDV'],
      tenLDV: json['tenLDV'],
      donGia: json['donGia'],
      soLuong: json['soLuong'],
      traTruoc: json['traTruoc'],
      thanhTien: json['thanhTien'],
      conLai: json['conLai'],
      ngayGiao: json['ngayGiao'],
      tinhTrang: json['tinhTrang'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soPhieuDV': soPhieuDV,
      'maLDV': maLDV,
      'tenLDV': tenLDV,
      'donGia': donGia,
      'soLuong': soLuong,
      'traTruoc': traTruoc,
      'thanhTien': thanhTien,
      'conLai': conLai,
      'ngayGiao': ngayGiao,
      'tinhTrang': tinhTrang,
    };
  }
}
