import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class LoaiDichVu {
  final String maLDV;
  final String tenLDV;
  final int donGia;
  final double traTruoc;

  LoaiDichVu({
    required this.maLDV,
    required this.tenLDV,
    required this.donGia,
    required this.traTruoc,
  });

  factory LoaiDichVu.fromJson(Map<String, dynamic> json) {
    return LoaiDichVu(
      maLDV: json['maLDV'],
      tenLDV: json['tenLDV'],
      donGia: json['donGia'],
      traTruoc: json['traTruoc'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maLDV': maLDV,
      'tenLDV': tenLDV,
      'donGia': donGia,
      'traTruoc': traTruoc,
    };
  }

  static List<LoaiDichVu> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LoaiDichVu.fromJson(json as Map<String, dynamic>)).toList();
  }

  static List<TableRowData> convertToTableRowData(List<LoaiDichVu> data) {
    return data.map((ldv) {
      return TableRowData(
        id: ldv.maLDV,
        data: {
          'name': ldv.tenLDV,
          'price': ldv.donGia,
          'prepaid': ldv.traTruoc,
        },
      );
    }).toList();
  }
}
