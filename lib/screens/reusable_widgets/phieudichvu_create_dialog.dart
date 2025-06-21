import 'package:flutter/material.dart';
import 'package:gemstore_frontend/config/format.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/date_input_field.dart';

class PhieuDichVuCreateDialog extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> listLoaiDichVu;
  final Function(String, String, List<Map<String, dynamic>>) onCreate;
  final DateTime currentDate;
  final int soNgayGiaoToiDa;

  const PhieuDichVuCreateDialog({
    super.key,
    required this.title,
    required this.listLoaiDichVu,
    required this.onCreate,
    required this.currentDate,
    required this.soNgayGiaoToiDa,
  });

  @override
  State<PhieuDichVuCreateDialog> createState() =>
      _PhieuDichVuCreateDialogState();

}

class _PhieuDichVuCreateDialogState extends State<PhieuDichVuCreateDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _khachHangController = TextEditingController();
  final TextEditingController _sdtController = TextEditingController();
  final List<DichVu> _dichVuList = [];
  final List<TextEditingController> _dichVuControllers = [];
  final List<TextEditingController> _soLuongControllers = [];
  final List<TextEditingController> _ngayGiaoControllers = [];
  final List<TextEditingController> _tongTienTraTruocControllers = [];
  final List<bool> _tinhTrang = [];

  @override
  void initState() {
    super.initState();
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
          soPhieuDV: "",
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

  String? _validateKhachHang(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên khách hàng';
    }
    return null;
  }

  String? _validateSdt(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập số điện thoại';
    }
    
    // Remove all non-digit characters for validation
    String cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (cleanedValue.length < 10) {
      return 'Số điện thoại phải có ít nhất 10 chữ số';
    }
    
    if (cleanedValue.length > 15) {
      return 'Số điện thoại không được vượt quá 15 chữ số';
    }
    
    return null;
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
              TextFormField(
                controller: _khachHangController,
                decoration: const InputDecoration(labelText: 'Khách hàng'),
                validator: _validateKhachHang,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _sdtController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: _validateSdt,
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
              widget.onCreate(
                _khachHangController.text,
                _sdtController.text,
                _dichVuList.map((item) => item.toJson()).toList(),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('Tạo phiếu'),
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