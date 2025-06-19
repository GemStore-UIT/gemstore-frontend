import 'package:gemstore_frontend/models/don_vi_tinh.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class LoaiSanPham {
  String maLSP;
  String tenLSP;
  DonViTinh donViTinh;
  double loiNhuan;

  LoaiSanPham({
    required this.maLSP,
    required this.tenLSP,
    required this.donViTinh,
    required this.loiNhuan,
  });

  factory LoaiSanPham.fromJson(Map<String, dynamic> json) {
    return LoaiSanPham(
      maLSP: json['maLSP'],
      tenLSP: json['tenLSP'],
      donViTinh: DonViTinh.fromJson(json['donViTinh']),
      loiNhuan: json['loiNhuan']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maLSP': maLSP,
      'tenLSP': tenLSP,
      'donViTinh': donViTinh.toJson(),
      'loiNhuan': loiNhuan,
    };
  }

  static List<LoaiSanPham> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LoaiSanPham.fromJson(json as Map<String, dynamic>)).toList();
  }

  static List<TableRowData> convertToTableRowData(List<LoaiSanPham> data) {
    return data.map((lsp) {
      return TableRowData(
        id: lsp.maLSP,
        data: {
          'name': lsp.tenLSP,
          'unit': lsp.donViTinh.tenDonVi,
          'profit': lsp.loiNhuan.toString(),
        },
      );
    }).toList();
  }
}
