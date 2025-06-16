import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_event.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/bloc/loai_san_pham_state.dart';
import 'package:gemstore_frontend/features/home/loai_san_pham/loai_san_pham_repository.dart';

class LoaiSanPhamBloc extends Bloc<LoaiSanPhamEvent, LoaiSanPhamState> {
  LoaiSanPhamBloc(this.loaiSanPhamRepository) : super(LoaiSanPhamInitial()) {
    on<LoaiSanPhamEventStart>(_onStart);
    on<LoaiSanPhamEventAdd>(_onAdd);
    on<LoaiSanPhamEventUpdate>(_onUpdate);
    on<LoaiSanPhamEventDelete>(_onDelete);
    on<LoaiSanPhamEventGetAll>(_onGetAll);
    on<LoaiSanPhamEventGetById>(_onGetById);
  }

  final LoaiSanPhamRepository loaiSanPhamRepository;

  void _onStart(
    LoaiSanPhamEventStart event,
    Emitter<LoaiSanPhamState> emit,
  ) {
    emit(LoaiSanPhamInitial());
  }

  void _onAdd(
    LoaiSanPhamEventAdd event,
    Emitter<LoaiSanPhamState> emit,
  ) {
    // Implement add logic here
  }

  void _onUpdate(
    LoaiSanPhamEventUpdate event,
    Emitter<LoaiSanPhamState> emit,
  ) {
    // Implement update logic here
  }

  void _onDelete(
    LoaiSanPhamEventDelete event,
    Emitter<LoaiSanPhamState> emit,
  ) {
    // Implement delete logic here
  }

  void _onGetAll(
    LoaiSanPhamEventGetAll event,
    Emitter<LoaiSanPhamState> emit,
  ) async {
    try {
      emit(LoaiSanPhamLoading());
      final data = await loaiSanPhamRepository.getAll();
      emit(LoaiSanPhamFetchingSuccess(loaiSanPhamRepository.convertToTableRowData(data)));
    } catch (e) {
      emit(LoaiSanPhamFetchingFailure(e.toString()));
    }
  }

  void _onGetById(
    LoaiSanPhamEventGetById event,
    Emitter<LoaiSanPhamState> emit,
  ) async {
    // Implement get by id logic here
  }

}
