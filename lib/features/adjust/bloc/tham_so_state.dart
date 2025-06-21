import 'package:gemstore_frontend/models/tham_so.dart';

sealed class ThamSoState {}

class ThamSoStateInitial extends ThamSoState {}

class ThamSoStateLoading extends ThamSoState {}

class ThamSoStateLoaded extends ThamSoState {
  final List<ThamSo> thamSoList;

  ThamSoStateLoaded(this.thamSoList);
}

class ThamSoStateError extends ThamSoState {
  final String message;

  ThamSoStateError(this.message);
}
