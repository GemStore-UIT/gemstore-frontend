import 'package:gemstore_frontend/screens/home/view_list/bao_cao_screen.dart';

sealed class BaoCaoState {}

class BaoCaoStateInitial extends BaoCaoState {}

class BaoCaoStateLoading extends BaoCaoState {}

class BaoCaoStateSuccess extends BaoCaoState {
  final int month;
  final int year;
  final List<ProductData> data;

  BaoCaoStateSuccess(this.month, this.year, this.data);
}

class BaoCaoStateError extends BaoCaoState {
  final String message;

  BaoCaoStateError(this.message);
}
