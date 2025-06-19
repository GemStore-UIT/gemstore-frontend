import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_event.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_state.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham_repository.dart';

class LoaiSanPhamBloc extends Bloc<LoaiSanPhamEvent, LoaiSanPhamState> {
  LoaiSanPhamBloc(this.loaiSanPhamRepository) : super(LoaiSanPhamStateInitial()) {
    on<LoaiSanPhamEventStart>(_onStart);
    on<LoaiSanPhamEventCreate>(_onCreate);
    on<LoaiSanPhamEventUpdate>(_onUpdate);
    on<LoaiSanPhamEventDelete>(_onDelete);
    on<LoaiSanPhamEventGetAll>(_onGetAll);
  }

  final LoaiSanPhamRepository loaiSanPhamRepository;

  void _onStart(
    LoaiSanPhamEventStart event,
    Emitter<LoaiSanPhamState> emit,
  ) {
    emit(LoaiSanPhamStateInitial());
  }

  void _onCreate(
    LoaiSanPhamEventCreate event,
    Emitter<LoaiSanPhamState> emit,
  ) async {
    emit(LoaiSanPhamStateLoading());
    try {
      await loaiSanPhamRepository.create(event.tenLSP, event.donViTinh, event.loiNhuan);
      add(LoaiSanPhamEventGetAll());
    } catch (error) {
      emit(LoaiSanPhamStateFailure(error.toString()));
    }
  }

  void _onUpdate(
    LoaiSanPhamEventUpdate event,
    Emitter<LoaiSanPhamState> emit,
  ) async {
    emit(LoaiSanPhamStateLoading());
    try {
      await loaiSanPhamRepository.update(event.loaiSanPham);
      add(LoaiSanPhamEventGetAll());
    } catch (error) {
      emit(LoaiSanPhamStateFailure(error.toString()));
    }
  }

  void _onDelete(
    LoaiSanPhamEventDelete event,
    Emitter<LoaiSanPhamState> emit,
  ) async {
    emit(LoaiSanPhamStateLoading());
    try {
      await loaiSanPhamRepository.delete(event.maLSP);
      add(LoaiSanPhamEventGetAll());
    } catch (error) {
      emit(LoaiSanPhamStateFailure(error.toString()));
    }
  }

  void _onGetAll(
    LoaiSanPhamEventGetAll event,
    Emitter<LoaiSanPhamState> emit,
  ) async {
    try {
      emit(LoaiSanPhamStateLoading());
      final data = await loaiSanPhamRepository.getAll();
      emit(LoaiSanPhamStateUpdated(data));
    } catch (e) {
      emit(LoaiSanPhamStateFailure(e.toString()));
    }
  }
}
