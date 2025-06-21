class ThamSo {
  String tenThamSo;
  double giaTri;

  ThamSo({
    required this.tenThamSo,
    required this.giaTri,
  });

  factory ThamSo.fromJson(Map<String, dynamic> json) {
    return ThamSo(
      tenThamSo: json['tenThamSo'],
      giaTri: json['giaTri'].toDouble(),
    );
  }

  static List<ThamSo> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ThamSo.fromJson(json as Map<String, dynamic>)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'tenThamSo': tenThamSo,
      'giaTri': giaTri,
    };
  }
}
