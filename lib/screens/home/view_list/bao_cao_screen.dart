// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/report/bloc/bao_cao_bloc.dart';
import 'package:gemstore_frontend/features/report/bloc/bao_cao_event.dart';
import 'package:gemstore_frontend/features/report/bloc/bao_cao_state.dart';

class ReportScreen extends StatefulWidget {
  final Map<String, Map<String, double>> chartData;

  const ReportScreen({super.key, required this.chartData});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String selectedMonth = 'Tháng 6/2025';
  bool _isLoadingProducts = false;

  // Dữ liệu mẫu cho dropdown
  List<String> months = [];
  final Map<String, List<ProductData>> _productData = {};

  @override
  void initState() {
    super.initState();
    final chartMonths = widget.chartData.keys.toSet();
    months = chartMonths.toList();
    months
        .sort(); // Sắp xếp tăng dần theo tên tháng (nếu cần sắp xếp theo thời gian thực, cần xử lý thêm)
    selectedMonth = months.first; // Mặc định chọn tháng đầu tiên
    _getProductData(selectedMonth);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BaoCaoBloc, BaoCaoState>(
      listener: (context, state) {
        setState(() {
          _isLoadingProducts = state is BaoCaoStateLoading;
          if (state is BaoCaoStateSuccess) {
            _productData['Tháng ${state.month}/${state.year}'] = state.data;
          } else if (state is BaoCaoStateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Lỗi tải dữ liệu: ${state.message}')),
            );
          }
        });
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hàng chứa dropdown và nút xuất báo cáo
                Row(
                  children: [
                    Expanded(child: _buildMonthSelector()),
                    SizedBox(width: 16),
                    _buildExportButton(),
                  ],
                ),
                SizedBox(height: 20),

                // Layout chính với biểu đồ bên phải
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Phần bên trái - Danh sách sản phẩm
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chi tiết sản phẩm',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            SizedBox(height: 10),
                            _isLoadingProducts
                                ? Expanded(
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : Expanded(child: _buildProductList()),
                          ],
                        ),
                      ),

                      SizedBox(width: 20),

                      // Phần bên phải - Biểu đồ
                      Expanded(flex: 1, child: _buildChart()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedMonth,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down, color: Colors.blue[600]),
          style: TextStyle(fontSize: 16, color: Colors.grey[800]),
          items:
              months.map((String month) {
                return DropdownMenuItem<String>(
                  value: month,
                  child: Text(month),
                );
              }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                selectedMonth = newValue;
                _getProductData(selectedMonth);
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildChart() {
    final data = widget.chartData[selectedMonth]!;
    return Container(
      height: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Doanh thu $selectedMonth',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 5000000000,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      String type = group.x.toInt() == 0 ? 'Mua vào' : 'Bán ra';
                      return BarTooltipItem(
                        '$type\n${_formatCurrency(rod.toY)}',
                        TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        switch (value.toInt()) {
                          case 0:
                            return Text(
                              'Mua vào',
                              style: TextStyle(fontSize: 12),
                            );
                          case 1:
                            return Text(
                              'Bán ra',
                              style: TextStyle(fontSize: 12),
                            );
                          default:
                            return Text('');
                        }
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 60,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${(value / 1000000).toInt()}M',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: data['mua_vao']!,
                        color: Colors.orange[600],
                        width: 30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: data['ban_ra']!,
                        color: Colors.green[600],
                        width: 30,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Column(
            children: [
              _buildLegendItem('Mua vào', Colors.orange[600]!),
              SizedBox(height: 8),
              _buildLegendItem('Bán ra', Colors.green[600]!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildProductList() {
    final products = _productData[selectedMonth] ?? [];

    if (products.isEmpty) {
      return Center(
        child: Text(
          'Không có dữ liệu cho $selectedMonth',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        children: [
          // Header của bảng
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Sản phẩm', style: _headerStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Tồn đầu',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Mua vào',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Bán ra',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Tồn cuối',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'ĐVT',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Danh sách sản phẩm
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          product.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.tonDau.toString(),
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.muaVao.toString(),
                          style: _cellStyle(Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.banRa.toString(),
                          style: _cellStyle(Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.tonCuoi.toString(),
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.donViTinh,
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle() {
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.grey[700],
    );
  }

  TextStyle _cellStyle(Color? color) {
    return TextStyle(fontSize: 13, color: color ?? Colors.grey[800]);
  }

  Widget _buildExportButton() {
    return ElevatedButton.icon(
      onPressed: _showExportDialog,
      icon: Icon(Icons.file_download, size: 18),
      label: Text('Xuất báo cáo'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[600],
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
      ),
    );
  }

  void _showExportDialog() {
    final data = widget.chartData[selectedMonth]!;
    final products = _productData[selectedMonth] ?? [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Báo cáo bán hàng - $selectedMonth',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                Divider(),
                SizedBox(height: 16),

                // Thông tin tổng quan
                _buildSummarySection(data),
                SizedBox(height: 20),

                // Chi tiết sản phẩm
                Text(
                  'Chi tiết sản phẩm',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 12),

                // Bảng sản phẩm
                Expanded(child: _buildExportProductTable(products)),
                SizedBox(height: 20),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Đóng'),
                    ),
                    SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () => _exportToPDF(),
                      icon: Icon(Icons.picture_as_pdf, size: 18),
                      label: Text('Xuất PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _exportToExcel(),
                      icon: Icon(Icons.table_chart, size: 18),
                      label: Text('Xuất Excel'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummarySection(Map<String, double> data) {
    double loiNhuan = data['ban_ra']! - data['mua_vao']!;
    double tyLeLoi = (loiNhuan / data['mua_vao']!) * 100;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tổng quan doanh thu',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Tổng mua vào',
                  _formatCurrency(data['mua_vao']!),
                  Icons.shopping_cart,
                  Colors.orange[600]!,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Tổng bán ra',
                  _formatCurrency(data['ban_ra']!),
                  Icons.sell,
                  Colors.green[600]!,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  'Lợi nhuận',
                  _formatCurrency(loiNhuan),
                  Icons.trending_up,
                  loiNhuan >= 0 ? Colors.green[600]! : Colors.red[600]!,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  'Tỷ lệ lợi nhuận',
                  '${tyLeLoi.toStringAsFixed(1)}%',
                  Icons.percent,
                  tyLeLoi >= 0 ? Colors.green[600]! : Colors.red[600]!,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: EdgeInsets.only(right: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExportProductTable(List<ProductData> products) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Tên sản phẩm', style: _headerStyle()),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Tồn đầu',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Mua vào',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Bán ra',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Tồn cuối',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Đơn vị',
                    style: _headerStyle(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          // Data rows
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: index % 2 == 0 ? Colors.white : Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(product.name, style: _cellStyle(null)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.tonDau.toString(),
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.muaVao.toString(),
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.banRa.toString(),
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.tonCuoi.toString(),
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          product.donViTinh,
                          style: _cellStyle(null),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _exportToPDF() {
    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Đã xuất báo cáo PDF thành công!'),
          ],
        ),
        backgroundColor: Colors.green[600],
        duration: Duration(seconds: 3),
      ),
    );
  }

  String _formatCurrency(double value) {
    return '${(value / 1000000).toStringAsFixed(0)}M VNĐ';
  }

  void _exportToExcel() {}

  void _getProductData(String selectedMonth) {
    final thang = extractMonth(selectedMonth);
    final nam = extractYear(selectedMonth);
    if (thang != null && nam != null) {
      context.read<BaoCaoBloc>().add(BaoCaoEventGet(thang, nam));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông tin tháng/năm không hợp lệ')),
      );
    }
  }

  int? extractMonth(String input) {
    final regex = RegExp(r'Tháng\s+(\d{1,2})/(\d{4})');
    final match = regex.firstMatch(input.trim());
    if (match != null) {
      return int.tryParse(match.group(1)!);
    }
    return null;
  }

  int? extractYear(String input) {
    final regex = RegExp(r'Tháng\s+(\d{1,2})/(\d{4})');
    final match = regex.firstMatch(input.trim());
    if (match != null) {
      return int.tryParse(match.group(2)!);
    }
    return null;
  }
}

// Model class cho dữ liệu sản phẩm
class ProductData {
  final String name;
  final int tonDau;
  final int muaVao;
  final int banRa;
  final int tonCuoi;
  final String donViTinh;

  ProductData(
    this.name,
    this.tonDau,
    this.muaVao,
    this.banRa,
    this.tonCuoi,
    this.donViTinh,
  );

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      json['tenSanPham'] as String,
      json['tonDau'] as int,
      json['muaVao'] as int,
      json['banRa'] as int,
      json['tonCuoi'] as int,
      json['donViTinh'] as String,
    );
  }
}
