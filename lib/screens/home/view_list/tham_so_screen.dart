import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gemstore_frontend/models/tham_so.dart';

class ThamSoScreen extends StatefulWidget {
  final List<ThamSo> thamSoList;
  final Function(List<ThamSo>)? onUpdate; // Callback để cập nhật dữ liệu

  const ThamSoScreen({
    super.key, 
    required this.thamSoList,
    this.onUpdate,
  });

  @override
  State<ThamSoScreen> createState() => _ThamSoScreenState();
}

class _ThamSoScreenState extends State<ThamSoScreen> {
  late List<ThamSo> _thamSoList;
  late List<TextEditingController> _controllers;
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Tạo bản sao của danh sách để có thể chỉnh sửa
    _thamSoList = List.from(widget.thamSoList);
    
    // Khởi tạo controllers cho mỗi tham số
    _controllers = _thamSoList.map((thamSo) => 
      TextEditingController(text: thamSo.giaTri.toString())
    ).toList();
  }

  @override
  void dispose() {
    // Giải phóng memory của controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  // Hàm để hiển thị tên tham số dễ đọc
  String _getDisplayName(String tenThamSo) {
    switch (tenThamSo) {
      case 'SoLuongTonToiThieu':
        return 'Số lượng tồn tối thiểu (sản phẩm)';
      case 'TiLeTraTruocMacDinh':
        return 'Tỷ lệ trả trước mặc định (%)';
      case 'SoNgayGiaoToiDa':
        return 'Số ngày giao hàng tối đa (ngày)';
      default:
        return tenThamSo;
    }
  }

  // Hàm để lấy đơn vị của tham số
  String _getUnit(String tenThamSo) {
    switch (tenThamSo) {
      case 'SoLuongTonToiThieu':
        return 'sản phẩm';
      case 'TiLeTraTruocMacDinh':
        return '%';
      case 'SoNgayGiaoToiDa':
        return 'ngày';
      default:
        return '';
    }
  }

  // Validator cho các ô nhập
  String? _validateGiaTri(String? value) {
    if (value == null || value.isEmpty) {
      return 'Vui lòng nhập giá trị';
    }
    
    final number = int.tryParse(value);
    if (number == null) {
      return 'Vui lòng nhập số nguyên hợp lệ';
    }
    
    if (number <= 0) {
      return 'Giá trị phải lớn hơn 0';
    }
    
    return null;
  }

  // Hàm lưu các thay đổi
  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Cập nhật giá trị trong danh sách
      for (int i = 0; i < _thamSoList.length; i++) {
        _thamSoList[i].giaTri = int.parse(_controllers[i].text).toInt();
      }
      
      // Gọi callback để cập nhật dữ liệu ở parent widget
      if (widget.onUpdate != null) {
        widget.onUpdate!(_thamSoList);
      }
      
      setState(() {
        _isEditing = false;
      });
      
      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cập nhật thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  // Hàm hủy thay đổi
  void _cancelChanges() {
    // Reset controllers về giá trị ban đầu
    for (int i = 0; i < _controllers.length; i++) {
      _controllers[i].text = widget.thamSoList[i].giaTri.toString();
    }
    
    setState(() {
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              tooltip: 'Chỉnh sửa',
            ),
          if (_isEditing) ...[
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _cancelChanges,
              tooltip: 'Hủy',
            ),
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: _saveChanges,
              tooltip: 'Lưu',
            ),
          ],
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: _thamSoList.length,
          itemBuilder: (context, index) {
            final thamSo = _thamSoList[index];
            
            return Card(
              margin: const EdgeInsets.only(bottom: 12.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getDisplayName(thamSo.tenThamSo),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getDisplayName(thamSo.tenThamSo),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_isEditing)
                      TextFormField(
                        controller: _controllers[index],
                        decoration: InputDecoration(
                          labelText: 'Giá trị',
                          border: const OutlineInputBorder(),
                          prefixIcon: const Icon(Icons.numbers),
                          suffixText: _getUnit(thamSo.tenThamSo),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _validateGiaTri,
                      )
                    else
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(4),
                          color: Colors.grey[50],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.numbers, color: Colors.grey),
                            const SizedBox(width: 12),
                            Text(
                              'Giá trị: ${thamSo.giaTri.toInt()} ${_getUnit(thamSo.tenThamSo)}',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}