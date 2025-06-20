import 'package:gemstore_frontend/models/phieu_ban_hang.dart';
import 'package:gemstore_frontend/models/phieu_mua_hang.dart';
import 'package:gemstore_frontend/models/san_pham.dart';
import 'package:gemstore_frontend/screens/home/view_list/bao_cao_screen.dart';

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
      final MM = dateTime.month.toString().padLeft(2, '0');
      final yyyy = dateTime.year.toString();

      return '$hh:$mm:$ss $dd/$MM/$yyyy';
    } catch (e) {
      return '{Invalid date}';
    }
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

  static Map<String, List<ProductData>> productDataFormat(
    List<SanPham> sanPhams,
    List<PhieuMuaHang> phieuMuaHangs,
    List<PhieuBanHang> phieuBanHangs,
  ) {
    Map<String, List<ProductData>> productData = {
      'Tháng 5/2024': [],
      'Tháng 6/2025': [],
    };

    // Xử lý từng sản phẩm
    for (var sanPham in sanPhams) {
      productData['Tháng 6/2025']!.add(
        ProductData(
          sanPham.tenSanPham,
          sanPham.tonKho,
          0,
          0,
          sanPham.tonKho,
          sanPham.loaiSanPham.donViTinh.tenDonVi,
        ),
      );
    }

    return productData;
  }
}
