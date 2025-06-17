import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class NhaCungCap {
  String maNCC;
  String tenNCC;
  String diaChi;
  String sdt;

  NhaCungCap({
    required this.maNCC,
    required this.tenNCC,
    required this.diaChi,
    required this.sdt,
  });

  factory NhaCungCap.fromJson(Map<String, dynamic> json) {
    return NhaCungCap(
      maNCC: json['maNCC'] as String,
      tenNCC: json['tenNCC'] as String,
      diaChi: json['diaChi'] as String,
      sdt: json['sdt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maNCC': maNCC,
      'tenNCC': tenNCC,
      'diaChi': diaChi,
      'sdt': sdt,
    };
  }

  static List<NhaCungCap> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => NhaCungCap.fromJson(json as Map<String, dynamic>)).toList();
  }

  static List<TableRowData> convertToTableRowData(List<NhaCungCap> data) {
    return data.map((ncc) {
      return TableRowData(
        id: ncc.maNCC,
        data: {
          'name': ncc.tenNCC,
          'address': ncc.diaChi,
          'phone': ncc.sdt,
        },
      );
    }).toList();
  }
}
