import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_state.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu_repository.dart';


class LoaiDichVuBloc extends Bloc<LoaiDichVuEvent, LoaiDichVuState> {
  LoaiDichVuBloc(this.loaiDichVuRepository) : super(LoaiDichVuInitial()) {
    on<LoaiDichVuEventStart>(_onStart);
    on<LoaiDichVuEventAdd>(_onAdd);
    on<LoaiDichVuEventUpdate>(_onUpdate);
    on<LoaiDichVuEventDelete>(_onDelete);
    on<LoaiDichVuEventGetAll>(_onGetAll);
    on<LoaiDichVuEventGetById>(_onGetById);
    on<LoaiDichVuEventGetByName>(_onGetByName);
  }

  final LoaiDichVuRepository loaiDichVuRepository;

  void _onStart(
    LoaiDichVuEventStart event,
    Emitter<LoaiDichVuState> emit,
  ) {
    emit(LoaiDichVuInitial());
  }

  void _onAdd(
    LoaiDichVuEventAdd event,
    Emitter<LoaiDichVuState> emit,
  ) {
    // Implement add logic here
  }

  void _onUpdate(
    LoaiDichVuEventUpdate event,
    Emitter<LoaiDichVuState> emit,
  ) {
    // Implement update logic here
  }

  void _onDelete(
    LoaiDichVuEventDelete event,
    Emitter<LoaiDichVuState> emit,
  ) {
    // Implement delete logic here
  }

  void _onGetAll(
    LoaiDichVuEventGetAll event,
    Emitter<LoaiDichVuState> emit,
  ) async {
    try {
      emit(LoaiDichVuLoading());
      final data = await loaiDichVuRepository.getAll();
      emit(LoaiDichVuFetchingSuccess(loaiDichVuRepository.convertToTableRowData(data)));
    } catch (e) {
      emit(LoaiDichVuFetchingFailure(e.toString()));
    }
  }

  void _onGetById(
    LoaiDichVuEventGetById event,
    Emitter<LoaiDichVuState> emit,
  ) async {

  }


  FutureOr<void> _onGetByName(LoaiDichVuEventGetByName event, Emitter<LoaiDichVuState> emit) async {
  }
}
