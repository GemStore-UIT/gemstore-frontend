import 'package:gemstore_frontend/features/home/api_clients/nha_cung_cap_api_client.dart';
import 'package:gemstore_frontend/features/home/data/base_repository.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

class NhaCungCapModel {
  final String id;
  final String name;
  final String address;
  final String phone;

  NhaCungCapModel({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
  });

  factory NhaCungCapModel.fromJson(Map<String, dynamic> json) {
    return NhaCungCapModel(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}

class NhaCungCapRepository extends BaseRepository{
  final NhaCungCapApiClient nhaCungCapApiClient;
  List<NhaCungCapModel> _allSuppliers = [];
  List<TableRowData> _data = [];
  final List<TableColumn> _columns = [
    TableColumn(key: 'name', header: 'Tên nhà cung cấp', width: 2),
    TableColumn(key: 'address', header: 'Địa chỉ', width: 3),
    TableColumn(
      key: 'phone',
      header: 'Số điện thoại',
      width: 2,
      validator:
          (value) => (value.trim().length < 10 || value.trim().length > 15) ? false : true,
      errorMessage: 'Số điện thoại phải từ 10 đến 15 ký tự',
    ),
  ];

  NhaCungCapRepository({required this.nhaCungCapApiClient});

  Future<void> fetchNhaCungCap() async {
    try {
      onLoading();
      final result = await nhaCungCapApiClient.getAllNhaCungCap();
      _allSuppliers = result;
      onSuccess();
    } catch (e) {
      onError('Không thể tải danh sách nhà cung cấp: $e');
    } finally {
      convertToTableData();
    }
  }

  void convertToTableData() {
  _data = _allSuppliers.map((supplier) => TableRowData(
    id: supplier.id,
    data: {
      'name': supplier.name,
      'address': supplier.address,
      'phone': supplier.phone,
    },
  )).toList();
}

  @override
  List<TableRowData> getTableData() {
    _data = _allSuppliers.map((supplier) {
      return TableRowData(
        id: supplier.id,
        data: {
          'name': supplier.name,
          'address': supplier.address,
          'phone': supplier.phone,
        },
      );
    }).toList();
    return _data;
  }

  List<TableRowData> get data => _data;
  List<TableColumn> get columns => _columns;  
  
}
