class DonViTinh {
  String maDonVi;
  String tenDonVi;

  DonViTinh({
    required this.maDonVi,
    required this.tenDonVi,
  });

  factory DonViTinh.fromJson(Map<String, dynamic> json) {
  return DonViTinh(
    maDonVi: json['maDonVi'] as String,
    tenDonVi: json['tenDonVi'] as String,
  );
}

  Map<String, dynamic> toJson() {
    return {
      'maDonVi': maDonVi,
      'tenDonVi': tenDonVi,
    };
  }

  static List<DonViTinh> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => DonViTinh.fromJson(json as Map<String, dynamic>)).toList();
  }
}

