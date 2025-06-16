class LoaiDichVu {
  final String maLDV;
  final String tenLDV;
  final double donGia;
  final double traTruoc;

  LoaiDichVu({
    required this.maLDV,
    required this.tenLDV,
    required this.donGia,
    required this.traTruoc,
  });

  factory LoaiDichVu.fromJson(Map<String, dynamic> json) {
    return LoaiDichVu(
      maLDV: json['maLDV'] as String,
      tenLDV: json['tenLDV'] as String,
      donGia: (json['donGia'] as num?)?.toDouble() ?? 0.0,
      traTruoc: (json['traTruoc'] as num?)?.toDouble() ?? 0.0,
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
}
