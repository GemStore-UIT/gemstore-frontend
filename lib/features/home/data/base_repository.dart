import 'package:flutter/material.dart';
import 'package:gemstore_frontend/screens/reusable_widgets/reusable_table_widget.dart';

abstract class BaseRepository extends ChangeNotifier {
  bool _isLoading = true;
  bool _isError = false;
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;

  List<TableRowData> getTableData();

  void onLoading() {
    _isLoading = true;
    _isError = false;
    _errorMessage = '';
    notifyListeners();
  }

  void onSuccess() {
    _isError = false;
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  void onError(String message) {
    _isError = true;
    _errorMessage = message;
    _isLoading = false;
    notifyListeners();
  }
}
