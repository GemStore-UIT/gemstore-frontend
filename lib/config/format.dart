import 'package:gemstore_frontend/models/phieu_ban_hang.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/models/tham_so.dart';

class Format {
  static String moneyFormat(int amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.')} đ';
  }

  static String dateFormat(String date) {
    try {
      final dateTime = DateTime.parse(date);
      final hh = dateTime.hour.toString().padLeft(2, '0');
      final mm = dateTime.minute.toString().padLeft(2, '0');
      final ss = dateTime.second.toString().padLeft(2, '0');
      final dd = dateTime.day.toString().padLeft(2, '0');
      // ignore: non_constant_identifier_names
      final MM = dateTime.month.toString().padLeft(2, '0');
      final yyyy = dateTime.year.toString();

      return '$hh:$mm:$ss $dd/$MM/$yyyy';
    } catch (e) {
      return '{Invalid date}';
    }
  }

  static String percentageFormat(String value) {
    final num? number = num.tryParse(value);
    if (number == null) return '$value%';
    // If the value is an integer, format without decimals, else keep original
    if (number is int || number == number.roundToDouble()) {
      return '${number.toStringAsFixed(0)}%';
    }
    return '$value%';
  }

  static Map<String, Map<String, double>> chartDataFormat(
    List<PhieuMuaHang> phieuMuaHangs,
    List<PhieuBanHang> phieuBanHangs,
  ) {
    Map<String, Map<String, double>> chartData = {};

    // Xử lý dữ liệu mua vào
    for (var phieu in phieuMuaHangs) {
      final dateTime = DateTime.parse(phieu.ngayLap);
      final month = 'Tháng ${dateTime.month}/${dateTime.year}';

      if (!chartData.containsKey(month)) {
        chartData[month] = {'mua_vao': 0, 'ban_ra': 0};
      }
      chartData[month]!['mua_vao'] =
          (chartData[month]!['mua_vao'] ?? 0) + phieu.tongTien;
    }

    // Xử lý dữ liệu bán ra
    for (var phieu in phieuBanHangs) {
      final dateTime = DateTime.parse(phieu.ngayLap);
      final month = 'Tháng ${dateTime.month}/${dateTime.year}';

      if (!chartData.containsKey(month)) {
        chartData[month] = {'mua_vao': 0, 'ban_ra': 0};
      }
      chartData[month]!['ban_ra'] =
          (chartData[month]!['ban_ra'] ?? 0) + phieu.tongTien;
    }

    return chartData;
  }

  static int getSoNgayGiaoToiDa(List<ThamSo> thamSos) {
    final soNgayGiaoToiDa = thamSos.firstWhere(
      (thamSo) => thamSo.tenThamSo == 'SoNgayGiaoToiDa',
    );
    return soNgayGiaoToiDa.giaTri.toInt();
  }

  static double getTiLeTraTruocMacDinh(List<ThamSo> thamSos) {
    final tiLeTraTruocMacDinh = thamSos.firstWhere(
      (thamSo) => thamSo.tenThamSo == 'TiLeTraTruocMacDinh',
    );
    return tiLeTraTruocMacDinh.giaTri;
  }

  static int getSoLuongTonToiThieu(List<ThamSo> thamSos) {
    final soLuongTonToiThieu = thamSos.firstWhere(
      (thamSo) => thamSo.tenThamSo == 'SoLuongTonToiThieu',
    );
    return soLuongTonToiThieu.giaTri.toInt();
  }
}
