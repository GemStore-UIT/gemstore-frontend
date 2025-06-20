import 'package:flutter/material.dart';
import 'package:gemstore_frontend/config/format.dart';

class PhieumuabanUpdateDialog extends StatefulWidget {
  final String title;
  final String soPhieu;
  final String nguoiGiaoDich;
  final List<Map<String, dynamic>>? listNhaCungCap;
  final String ngayLap;
  final List<Map<String, dynamic>> chiTiet;
  final List<Map<String, dynamic>> listSanPham;
  final Function(Map<String, dynamic>) onUpdate;

  const PhieumuabanUpdateDialog({
    super.key,
    required this.title,
    required this.soPhieu,
    required this.nguoiGiaoDich,
    this.listNhaCungCap,
    required this.ngayLap,
    required this.chiTiet,
    required this.listSanPham,
    required this.onUpdate,
  });

  @override
  State<PhieumuabanUpdateDialog> createState() =>
      _PhieumuabanUpdateDialogState();
}

class _PhieumuabanUpdateDialogState extends State<PhieumuabanUpdateDialog> {
  late TextEditingController _soPhieuController;
  late TextEditingController _nguoiGiaoDichController;
  List<SanPhamMuaBan> _sanPhamMuaBanList = [];
  List<TextEditingController> _sanPhamControllers = [];
  List<TextEditingController> _soLuongControllers = [];

  @override
  void initState() {
    super.initState();
    _soPhieuController = TextEditingController(text: widget.soPhieu);
    _nguoiGiaoDichController = TextEditingController(
      text: widget.nguoiGiaoDich,
    );
    _sanPhamMuaBanList =
        widget.chiTiet
            .map((item) => SanPhamMuaBan.fromJson(item, widget.listSanPham))
            .toList();
    _sanPhamControllers = List.generate(
      _sanPhamMuaBanList.length,
      (index) =>
          TextEditingController(text: _sanPhamMuaBanList[index].tenSanPham),
    );
    _soLuongControllers = List.generate(
      _sanPhamMuaBanList.length,
      (index) => TextEditingController(
        text: _sanPhamMuaBanList[index].soLuong.toString(),
      ),
    );
  }

  @override
  void dispose() {
    _soPhieuController.dispose();
    _nguoiGiaoDichController.dispose();
    for (var controller in _sanPhamControllers) {
      controller.dispose();
    }
    for (var controller in _soLuongControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addSanPhamMuaBan() {
    setState(() {
      Map<String, dynamic> sanPham =
          widget.listSanPham.isNotEmpty
              ? widget.listSanPham.first
              : {'maSanPham': '', 'tenSanPham': '', 'thanhTien': 0};
      _sanPhamMuaBanList.add(
        SanPhamMuaBan(
          maSanPham: sanPham['maSanPham'] ?? '',
          tenSanPham: sanPham['tenSanPham'] ?? '',
          donGia: sanPham['donGia'] ?? 0,
          loiNhuan: sanPham['loaiSanPham']['loiNhuan'] ?? 0,
          soLuong: 1,
          thanhTien: widget.listNhaCungCap == null
              ? (sanPham['donGia'] * (100 + (sanPham['loaiSanPham']['loiNhuan'] ?? 0)) / 100).toInt()
              : sanPham['donGia'] ?? 0,
        ),
      );
      _sanPhamControllers.add(TextEditingController());
      _soLuongControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Cập nhật ${widget.title}'),
      content: SingleChildScrollView(
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
                    'Mã ${widget.title}',
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
                        widget.soPhieu,
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
                    'Mã ${widget.title} không thể thay đổi',
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
            if (widget.listNhaCungCap != null &&
                widget.listNhaCungCap!.isNotEmpty)
              DropdownButtonFormField<String>(
                value: _nguoiGiaoDichController.text,
                items:
                    widget.listNhaCungCap!
                        .map(
                          (ncc) => DropdownMenuItem<String>(
                            value: ncc['maNCC'],
                            child: Text(ncc['tenNCC']),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    _nguoiGiaoDichController.text = value;
                  }
                },
                decoration: const InputDecoration(labelText: 'Nhà cung cấp'),
              )
            else
              TextField(
                controller: _nguoiGiaoDichController,
                decoration: const InputDecoration(labelText: 'Khách hàng'),
              ),
            const SizedBox(height: 16),
            const Divider(),
            ..._sanPhamMuaBanList.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // STT
                    Text(
                      '${_sanPhamMuaBanList.indexOf(item) + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    // Dropdown sản phẩm (chiếm hết không gian còn lại)
                    Expanded(
                      flex: 4,
                      child: DropdownButtonFormField<String>(
                        value:
                            item.maSanPham.isNotEmpty ? item.maSanPham : null,
                        items:
                            widget.listSanPham
                                .map(
                                  (sp) => DropdownMenuItem<String>(
                                    value: sp['maSanPham'],
                                    child: Text(
                                      sp['tenSanPham'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final selected = widget.listSanPham.firstWhere(
                              (sp) => sp['maSanPham'] == value,
                            );
                            setState(() {
                              item.maSanPham = selected['maSanPham'];
                              item.tenSanPham = selected['tenSanPham'];
                              item.loiNhuan =
                                  selected['loaiSanPham']['loiNhuan'];
                              item.donGia = selected['donGia'] ?? 0;
                              item.updateThanhTien(
                                widget.listNhaCungCap == null,
                              );
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Sản phẩm',
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Số lượng (có kích thước giới hạn)
                    SizedBox(
                      width: 80,
                      child: TextFormField(
                        initialValue: item.soLuong.toString(),
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Số lượng',
                        ),
                        onChanged: (value) {
                          setState(() {
                            item.soLuong = int.tryParse(value) ?? 1;
                            item.updateThanhTien(
                              widget.listNhaCungCap == null,
                            );
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Thành tiền
                    Expanded(
                      flex: 3,
                      child: Text(
                        Format.moneyFormat(item.thanhTien),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 4),
                    // Nút xóa
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _sanPhamMuaBanList.remove(item);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            // Add button to add new item
            ElevatedButton(
              onPressed: () {
                _addSanPhamMuaBan();
              },
              child: const Text('Thêm sản phẩm'),
            ),
            // add a line and sum for thanhTien
            const Divider(),
            Text(
              'Tổng tiền: ${Format.moneyFormat(_sanPhamMuaBanList.fold<int>(0, (sum, item) => sum + item.thanhTien))}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
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
            final updatedData = {
              'id': _soPhieuController.text,
              'name': _nguoiGiaoDichController.text,
              'date': widget.ngayLap,
              'details':
                  _sanPhamMuaBanList.map((item) => item.toJson()).toList(),
            };
            widget.onUpdate(updatedData);
            Navigator.of(context).pop();
          },
          child: const Text('Cập nhật'),
        ),
      ],
    );
  }
}

class SanPhamMuaBan {
  String maSanPham;
  String tenSanPham;
  int donGia;
  double loiNhuan;
  int soLuong;
  int thanhTien;

  SanPhamMuaBan({
    required this.maSanPham,
    required this.tenSanPham,
    required this.donGia,
    required this.loiNhuan,
    required this.soLuong,
    required this.thanhTien,
  });

  factory SanPhamMuaBan.fromJson(
    Map<String, dynamic> json,
    List<Map<String, dynamic>> listSanPham,
  ) {
    return SanPhamMuaBan(
      maSanPham: json['maSanPham'],
      tenSanPham: json['tenSanPham'],
      donGia:
          listSanPham.firstWhere(
            (item) => item['maSanPham'] == json['maSanPham'],
          )['donGia'] ??
          0,
      loiNhuan:
          listSanPham.firstWhere(
            (item) => item['maSanPham'] == json['maSanPham'],
            orElse:
                () => {
                  'loaiSanPham': {'loiNhuan': 0},
                },
          )['loaiSanPham']['loiNhuan'] ??
          0,
      soLuong: json['soLuong'],
      thanhTien: json['thanhTien'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maSanPham': maSanPham,
      'tenSanPham': tenSanPham,
      'soLuong': soLuong,
      'thanhTien': thanhTien,
    };
  }

  int updateThanhTien(bool haveProfit) {
    if (haveProfit) {
      return thanhTien = (donGia * ((100 + loiNhuan) / 100) * soLuong).toInt();
    } else {
      return thanhTien = donGia * soLuong;
    }
  }
}
