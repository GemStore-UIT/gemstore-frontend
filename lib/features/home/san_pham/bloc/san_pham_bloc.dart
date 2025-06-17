import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_event.dart';
import 'package:gemstore_frontend/features/home/san_pham/bloc/san_pham_state.dart';
import 'package:gemstore_frontend/features/home/san_pham/san_pham_repository.dart';

class SanPhamBloc extends Bloc<SanPhamEvent, SanPhamState> {
  SanPhamBloc(this.sanPhamRepository) : super(SanPhamStateInitial()) {
    on<SanPhamEventStart>(_onStart);
    on<SanPhamEventGetAll>(_onGetAll);
    on<SanPhamEventCreate>(_onCreate);
    on<SanPhamEventDelete>(_onDelete);
    on<SanPhamEventUpdate>(_onUpdate);
  }

  final SanPhamRepository sanPhamRepository;

  void _onStart(SanPhamEventStart event, Emitter<SanPhamState> emit) {
    emit(SanPhamStateInitial());
  }

  void _onGetAll(SanPhamEventGetAll event, Emitter<SanPhamState> emit) async {
    try {
      emit(SanPhamStateLoading());
      final data = await sanPhamRepository.getAllSanPham();
      emit(SanPhamStateUpdated(data: data));
    } catch (e) {
      emit(SanPhamStateFailure(error: "Lỗi tải sản phẩm: ${e.toString()}"));
    }
  }

  void _onCreate(SanPhamEventCreate event, Emitter<SanPhamState> emit) async {
    try {
      emit(SanPhamStateLoading());
      await sanPhamRepository.create(
        tenSanPham: event.tenSanPham,
        loaiSanPham: event.loaiSanPham,
        donGia: event.donGia,
        tonKho: event.tonKho,
      );
      final data = await sanPhamRepository.getAllSanPham();
      emit(SanPhamStateUpdated(data: data));
    } catch (e) {
      emit(SanPhamStateFailure(error: "Lỗi tạo sản phẩm: ${e.toString()}"));
    }
  }

  void _onDelete(SanPhamEventDelete event, Emitter<SanPhamState> emit) async {
    try {
      emit(SanPhamStateLoading());
      await sanPhamRepository.delete(event.maSanPham);
      final data = await sanPhamRepository.getAllSanPham();
      emit(SanPhamStateUpdated(data: data));
    } catch (e) {
      emit(SanPhamStateFailure(error: "Lỗi xóa sản phẩm: ${e.toString()}"));
    }
  }

  void _onUpdate(SanPhamEventUpdate event, Emitter<SanPhamState> emit) async {
    try {
      emit(SanPhamStateLoading());
      await sanPhamRepository.update(event.sanPham);
      final data = await sanPhamRepository.getAllSanPham();
      emit(SanPhamStateUpdated(data: data));
    } catch (e) {
      emit(SanPhamStateFailure(error: "Lỗi cập nhật sản phẩm: ${e.toString()}"));
    }
  }
}
