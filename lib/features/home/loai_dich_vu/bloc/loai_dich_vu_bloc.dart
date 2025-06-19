import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/bloc/loai_dich_vu_state.dart';
import 'package:gemstore_frontend/features/home/loai_dich_vu/loai_dich_vu_repository.dart';

class LoaiDichVuBloc extends Bloc<LoaiDichVuEvent, LoaiDichVuState> {
  LoaiDichVuBloc(this.loaiDichVuRepository) : super(LoaiDichVuStateInitial()) {
    on<LoaiDichVuEventStart>(_onStart);
    on<LoaiDichVuEventGetAll>(_onGetAll);
    on<LoaiDichVuEventCreate>(_onCreate);
    on<LoaiDichVuEventUpdate>(_onUpdate);
    on<LoaiDichVuEventDelete>(_onDelete);
  }

  final LoaiDichVuRepository loaiDichVuRepository;

  void _onStart(
    LoaiDichVuEventStart event,
    Emitter<LoaiDichVuState> emit,
  ) {
    emit(LoaiDichVuStateInitial());
  }

  void _onGetAll(
    LoaiDichVuEventGetAll event,
    Emitter<LoaiDichVuState> emit,
  ) async {
    emit(LoaiDichVuStateLoading());
    try {
      final data = await loaiDichVuRepository.getAll();
      emit(LoaiDichVuStateUpdated(data));
    } catch (error) {
      emit(LoaiDichVuStateFailure(error.toString()));
    }
  }

  void _onCreate(
    LoaiDichVuEventCreate event,
    Emitter<LoaiDichVuState> emit,
  ) async {
    emit(LoaiDichVuStateLoading());
    try {
      await loaiDichVuRepository.create(event.tenLDV, event.donGia, event.traTruoc);
      add(LoaiDichVuEventGetAll());
    } catch (error) {
      emit(LoaiDichVuStateFailure(error.toString()));
    }
  }

  void _onUpdate(
    LoaiDichVuEventUpdate event,
    Emitter<LoaiDichVuState> emit,
  ) async {
    emit(LoaiDichVuStateLoading());
    try {
      await loaiDichVuRepository.update(event.loaiDichVu);
      add(LoaiDichVuEventGetAll());
    } catch (error) {
      emit(LoaiDichVuStateFailure(error.toString()));
    }
  }

  void _onDelete(
    LoaiDichVuEventDelete event,
    Emitter<LoaiDichVuState> emit,
  ) async {
    emit(LoaiDichVuStateLoading());
    try {
      await loaiDichVuRepository.delete(event.maLDV);
      add(LoaiDichVuEventGetAll());
    } catch (error) {
      emit(LoaiDichVuStateFailure(error.toString()));
    }
  }
}