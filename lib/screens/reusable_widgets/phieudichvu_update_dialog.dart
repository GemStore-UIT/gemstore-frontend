import 'package:flutter/material.dart';
import 'package:gemstore_frontend/config/format.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/date_input_field.dart';
import 'package:intl/intl.dart';

class PhieuDichVuUpdateDialog extends StatefulWidget {
  final String title;
  final String soPhieuDV;
  final String ngayLap;
  final String khachhang;
  final String sdt;
  final List<Map<String, dynamic>> chiTiet;
  final List<Map<String, dynamic>> listLoaiDichVu;
  final Function(Map<String, dynamic>) onUpdate;
  final DateTime currentDate;
  final int soNgayGiaoToiDa;

  const PhieuDichVuUpdateDialog({
    super.key,
    required this.title,
    required this.soPhieuDV,
    required this.khachhang,
    required this.sdt,
    required this.ngayLap,
    required this.chiTiet,
    required this.listLoaiDichVu,
    required this.onUpdate,
    required this.currentDate,
    required this.soNgayGiaoToiDa,
  });

  @override
  State<PhieuDichVuUpdateDialog> createState() =>
      _PhieuDichVuUpdateDialogState();
}

class _PhieuDichVuUpdateDialogState extends State<PhieuDichVuUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _khachHangController;
  late TextEditingController _sdtController;
  List<DichVu> _dichVuList = [];
  List<TextEditingController> _dichVuControllers = [];
  List<TextEditingController> _soLuongControllers = [];
  List<TextEditingController> _ngayGiaoControllers = [];
  List<TextEditingController> _tongTienTraTruocControllers = [];
  List<bool> _tinhTrang = [];

  @override
  void initState() {
    super.initState();
    _khachHangController = TextEditingController(text: widget.khachhang);
    _sdtController = TextEditingController(text: widget.sdt);
    _dichVuList =
        widget.chiTiet
            .map((item) => DichVu.fromJson(item, widget.listLoaiDichVu))
            .toList();
    _dichVuControllers = List.generate(
      _dichVuList.length,
      (index) => TextEditingController(text: _dichVuList[index].tenLoaiDichVu),
    );
    _soLuongControllers = List.generate(
      _dichVuList.length,
      (index) =>
          TextEditingController(text: _dichVuList[index].soLuong.toString()),
    );
    _ngayGiaoControllers = List.generate(
      _dichVuList.length,
      (index) => TextEditingController(
        text: DateFormat('dd/MM/yyyy').format(_dichVuList[index].ngayGiao),
      ),
    );
    _tongTienTraTruocControllers = List.generate(
      _dichVuList.length,
      (index) => TextEditingController(
        text: _dichVuList[index].tongTienTraTruoc.toString(),
      ),
    );
    _tinhTrang = List.generate(
      _dichVuList.length,
      (index) => _dichVuList[index].tinhTrang == 'Đã giao',
    );
  }

  @override
  void dispose() {
    _khachHangController.dispose();
    _sdtController.dispose();
    for (var controller in _dichVuControllers) {
      controller.dispose();
    }
    for (var controller in _soLuongControllers) {
      controller.dispose();
    }
    for (var controller in _ngayGiaoControllers) {
      controller.dispose();
    }
    for (var controller in _tongTienTraTruocControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addDichVu() {
    setState(() {
      Map<String, dynamic> dichVu = widget.listLoaiDichVu.first;
      _dichVuList.add(
        DichVu(
          soPhieuDV: widget.soPhieuDV,
          maLoaiDichVu: dichVu['maLDV'],
          tenLoaiDichVu: dichVu['tenLDV'],
          donGia: dichVu['donGia'] ?? 0,
          soLuong: 1,
          tongTien: dichVu['donGia'] ?? 0,
          ngayGiao: DateTime.now(),
          tiLeTraTruoc: dichVu['traTruoc'] ?? 0.0,
          tongTienTraTruoc: 0,
          tongTienConLai: dichVu['donGia'] ?? 0,
          tinhTrang: 'Chưa giao',
        ),
      );
      _dichVuControllers.add(TextEditingController());
      _soLuongControllers.add(TextEditingController(text: '1'));
      _ngayGiaoControllers.add(TextEditingController());
      _tongTienTraTruocControllers.add(TextEditingController(text: '0'));
      _tinhTrang.add(false);
    });
  }

  String? _validateSoLuong(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số lượng';
    }
    
    final soLuong = int.tryParse(value);
    if (soLuong == null) {
      return 'Phải là số nguyên';
    }
    
    if (soLuong <= 0) {
      return 'Phải lớn hơn 0';
    }
    
    return null;
  }

  String? _validateTraTruoc(String? value, DichVu dichVu) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập số tiền trả trước';
    }
    
    final traTruoc = int.tryParse(value);
    if (traTruoc == null) {
      return 'Số tiền trả trước phải là một số';
    }
    
    if (traTruoc < 0) {
      return 'Số tiền trả trước không được âm';
    }
    
    // Tính số tiền trả trước tối thiểu theo tỉ lệ phần trăm
    // tiLeTraTruoc là phần trăm (20, 30, ...), cần chia 100
    final minTraTruoc = (dichVu.donGia * dichVu.soLuong * dichVu.tiLeTraTruoc / 100).round();
    if (traTruoc < minTraTruoc) {
      return 'Ít nhất ${Format.moneyFormat(minTraTruoc)}';
    }
    
    // Không được vượt quá tổng tiền
    if (traTruoc > dichVu.tongTien) {
      return 'Không được vượt quá tổng tiền';
    }
    
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mã phiếu dịch vụ',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.lock, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 8),
                        Text(
                          widget.soPhieuDV,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mã phiếu dịch vụ không thể thay đổi',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          Format.dateFormat(widget.ngayLap),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
                TextFormField(
                controller: _khachHangController,
                decoration: const InputDecoration(labelText: 'Khách hàng'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập tên khách hàng';
                  }
                  return null;
                },
                ),
                const SizedBox(height: 8),
                TextFormField(
                controller: _sdtController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                  }
                  final phone = value.trim();
                  final phoneReg = RegExp(r'^\d{10,15}$');
                  if (!phoneReg.hasMatch(phone)) {
                  return 'Số điện thoại phải là số và từ 10 đến 15 chữ số';
                  }
                  return null;
                },
                ),
              const SizedBox(height: 16),
              const Divider(),
              ..._dichVuList.asMap().entries.map((entry) {
                final index = entry.key;
                final dichVu = entry.value;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // STT
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          '${index + 1}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Dropdown dịch vụ
                      Expanded(
                        flex: 3,
                        child: DropdownButtonFormField<String>(
                          value:
                              dichVu.maLoaiDichVu.isNotEmpty
                                  ? dichVu.maLoaiDichVu
                                  : null,
                          decoration: const InputDecoration(labelText: 'Dịch vụ'),
                          items:
                              widget.listLoaiDichVu
                                  .map(
                                    (sp) => DropdownMenuItem<String>(
                                      value: sp['maLDV'],
                                      child: Text(
                                        sp['tenLDV'],
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              final selected = widget.listLoaiDichVu.firstWhere(
                                (sp) => sp['maLDV'] == value,
                              );
                              setState(() {
                                dichVu.maLoaiDichVu = selected['maLDV'];
                                dichVu.tenLoaiDichVu = selected['tenLDV'];
                                dichVu.donGia = selected['donGia'] ?? 0;
                                dichVu.tiLeTraTruoc = selected['traTruoc'] ?? 0.0;
                                dichVu.updateTongTien();
                                // Reset lại controller trả trước để trigger validation
                                _tongTienTraTruocControllers[index].text = '0';
                                dichVu.tongTienTraTruoc = 0;
                                dichVu.updateTongTien();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Số lượng
                      SizedBox(
                        width: 100,
                        child: TextFormField(
                          controller: _soLuongControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Số lượng'),
                          validator: _validateSoLuong,
                          onChanged: (value) {
                            final soLuong = int.tryParse(value);
                            if (soLuong != null && soLuong > 0) {
                              setState(() {
                                dichVu.soLuong = soLuong;
                                dichVu.updateTongTien();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Input ngày giao
                      SizedBox(
                        width: 180,
                        child: DateInputFieldWithPicker(
                          controller: _ngayGiaoControllers[index],
                          labelText: 'Ngày giao',
                          current: widget.currentDate,
                          soNgayGiaoToiDa: widget.soNgayGiaoToiDa,
                          onDatePicked: (value) {
                            setState(() {
                              dichVu.ngayGiao = value!;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Số tiền trả trước
                      SizedBox(
                        width: 150,
                        child: TextFormField(
                          controller: _tongTienTraTruocControllers[index],
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Trả trước',
                          ),
                          validator: (value) => _validateTraTruoc(value, dichVu),
                          onChanged: (value) {
                            final traTruoc = int.tryParse(value);
                            if (traTruoc != null && traTruoc >= 0) {
                              setState(() {
                                dichVu.tongTienTraTruoc = traTruoc;
                                dichVu.updateTongTien();
                              });
                            }
                          },
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Thành tiền
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 12),
                          child: Column(
                            children: [
                              Text(
                                "Tổng: ${Format.moneyFormat(dichVu.tongTien)}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Còn lại: ${Format.moneyFormat(dichVu.tongTienConLai)}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Hiển thị số tiền trả trước tối thiểu
                              Text(
                                "Trả trước tối thiểu: ${Format.moneyFormat((dichVu.donGia * dichVu.soLuong * dichVu.tiLeTraTruoc / 100).round())}",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Nút đổi tình trạng
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: IconButton(
                          icon: Icon(
                            dichVu.tinhTrang == 'Đã giao'
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color:
                                dichVu.tinhTrang == 'Đã giao'
                                    ? Colors.green
                                    : Colors.grey,
                          ),
                          tooltip:
                              dichVu.tinhTrang == 'Đã giao'
                                  ? 'Đánh dấu chưa giao'
                                  : 'Đánh dấu đã giao',
                          onPressed: () {
                            setState(() {
                              dichVu.tinhTrang =
                                  dichVu.tinhTrang == 'Đã giao'
                                      ? 'Chưa giao'
                                      : 'Đã giao';
                            });
                          },
                        ),
                      ),

                      // Nút xóa
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _dichVuList.removeAt(index);
                              _dichVuControllers.removeAt(index);
                              _soLuongControllers.removeAt(index);
                              _ngayGiaoControllers.removeAt(index);
                              _tongTienTraTruocControllers.removeAt(index);
                              _tinhTrang.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),

              // Add button to add new item
              ElevatedButton(
                onPressed: () {
                  _addDichVu();
                },
                child: const Text('Thêm dịch vụ'),
              ),
              // add a line and sum for thanhTien
              const Divider(),
              Text(
                'Tổng tiền: ${Format.moneyFormat(_dichVuList.fold<int>(0, (sum, item) => sum + item.tongTien))}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                'Tổng tiền đã thanh toán: ${Format.moneyFormat(_dichVuList.fold<int>(0, (sum, item) => sum + item.tongTienTraTruoc))}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              Text(
                'Tổng tiền còn lại: ${Format.moneyFormat(_dichVuList.fold<int>(0, (sum, item) => sum + item.tongTienConLai))}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final updatedData = {
                'id': widget.soPhieuDV,
                'name': _khachHangController.text,
                'phone': _sdtController.text,
                'details': _dichVuList.map((item) => item.toJson()).toList(),
              };
              widget.onUpdate(updatedData);
              Navigator.of(context).pop();
            }
          },
          child: const Text('Cập nhật'),
        ),
      ],
    );
  }
}

class DichVu {
  String soPhieuDV;
  String maLoaiDichVu;
  String tenLoaiDichVu;
  int donGia;
  int soLuong;
  int tongTien;
  DateTime ngayGiao;
  double tiLeTraTruoc;
  int tongTienTraTruoc;
  int tongTienConLai;
  String tinhTrang;

  DichVu({
    required this.soPhieuDV,
    required this.maLoaiDichVu,
    required this.tenLoaiDichVu,
    required this.donGia,
    required this.soLuong,
    required this.tongTien,
    required this.ngayGiao,
    required this.tiLeTraTruoc,
    required this.tongTienTraTruoc,
    required this.tongTienConLai,
    required this.tinhTrang,
  });

  factory DichVu.fromJson(
    Map<String, dynamic> json,
    List<Map<String, dynamic>> listLoaiDichVu,
  ) {
    return DichVu(
      soPhieuDV: json['soPhieuDV'],
      maLoaiDichVu: json['maLDV'],
      tenLoaiDichVu: json['tenLDV'],
      donGia: json['donGia'],
      soLuong: json['soLuong'],
      tongTien: json['thanhTien'],
      tongTienTraTruoc: json['traTruoc'],
      tongTienConLai: json['conLai'],
      ngayGiao: DateTime.parse(json['ngayGiao']),
      tiLeTraTruoc:
          listLoaiDichVu.firstWhere(
            (dv) => dv['maLDV'] == json['maLDV'],
          )['traTruoc'] ??
          0.0,
      tinhTrang: json['tinhTrang'] ?? 'Chưa giao',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soPhieuDV': soPhieuDV,
      'maLDV': maLoaiDichVu,
      'soLuong': soLuong,
      'traTruoc': tongTienTraTruoc,
      'ngayGiao': ngayGiao.toIso8601String(),
      'tinhTrang': tinhTrang,
    };
  }

  void updateTongTien() {
    tongTien = donGia * soLuong;
    tongTienConLai = tongTien - tongTienTraTruoc;
  }
}