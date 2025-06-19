import 'package:gemstore_frontend/models/loai_san_pham.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class SanPham {
  String maSanPham;
  String tenSanPham;
  LoaiSanPham loaiSanPham;
  int donGia;
  int tonKho;

  SanPham({
    required this.maSanPham,
    required this.tenSanPham,
    required this.loaiSanPham,
    required this.donGia,
    required this.tonKho,
  });

  factory SanPham.fromJson(Map<String, dynamic> json) {
    return SanPham(
      maSanPham:  json['maSanPham'],
      tenSanPham: json['tenSanPham'],
      loaiSanPham: LoaiSanPham.fromJson(json['loaiSanPham'] as Map<String, dynamic>),
      donGia: json['donGia'],
      tonKho: json['tonKho'],
    );
  }

  static List<SanPham> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => SanPham.fromJson(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'maSanPham': maSanPham,
      'tenSanPham': tenSanPham,
      'loaiSanPham': loaiSanPham.toJson(),
      'donGia': donGia,
      'tonKho': tonKho,
    };
  }

  static List<TableRowData> convertToTableRowData(List<SanPham> data) {
    return data.map((sp) {
      return TableRowData(
        id: sp.maSanPham,
        data: {
          'name': sp.tenSanPham,
          'productType': sp.loaiSanPham.tenLSP,
          'unit': sp.loaiSanPham.donViTinh.tenDonVi,
          'price': sp.donGia.toString(),
          'quantity': sp.tonKho.toString(),
        },
      );
    }).toList();

  }
}
