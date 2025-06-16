import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_repository.dart';

class PhieuMuaHangBloc extends Bloc<PhieuMuaHangEvent, PhieuMuaHangState> {
  PhieuMuaHangBloc(this.phieuMuaHangRepository)
    : super(PhieuMuaHangStateInitial()) {
    on<PhieuMuaHangEventStart>(_onStart);
    on<PhieuMuaHangEventAdd>(_onAdd);
    on<PhieuMuaHangEventGetAll>(_onGetAll);
    on<PhieuMuaHangEventGetById>(_onGetById);
    on<PhieuMuaHangEventDelete>(_onDelete);
  }

  final PhieuMuaHangRepository phieuMuaHangRepository;

  void _onStart(PhieuMuaHangEventStart event, Emitter<PhieuMuaHangState> emit) {
    emit(PhieuMuaHangStateInitial());
  }

  void _onAdd(
    PhieuMuaHangEventAdd event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      await phieuMuaHangRepository.create(
        event.maNCC,
        event.sanPhamMua,
      );
      final data = await phieuMuaHangRepository.getAll();
      emit(
        PhieuMuaHangStateUpdated(
          phieuMuaHangRepository.convertToTableRowData(data),
        ),
      );
    } catch (e) {
      emit(PhieuMuaHangStateCreateFailure(e.toString()));
    }
  }

  void _onGetAll(
    PhieuMuaHangEventGetAll event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      final data = await phieuMuaHangRepository.getAll();
      final listSanPham = await phieuMuaHangRepository.getListSanPham();
      final listNhaCungCap = await phieuMuaHangRepository.getListNhaCungCap();
      emit(
        PhieuMuaHangStateInitialSuccess(
          phieuMuaHangRepository.convertToTableRowData(data),
          listSanPham,
          listNhaCungCap,
        ),
      );
    } catch (e) {
      emit(PhieuMuaHangStateInitialFailure(e.toString()));
    }
  }

  void _onGetById(
    PhieuMuaHangEventGetById event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      final data = await phieuMuaHangRepository.getById(event.maPhieu);
      emit(PhieuMuaHangStateGetDetailSuccess(data));
    } catch (e) {
      emit(PhieuMuaHangStateGetDetailFailure(e.toString()));
    }
  }

  void _onDelete(
    PhieuMuaHangEventDelete event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      await phieuMuaHangRepository.delete(event.maPhieu);
      final data = await phieuMuaHangRepository.getAll();
      emit(
        PhieuMuaHangStateUpdated(
          phieuMuaHangRepository.convertToTableRowData(data),
        ),
      );
    } catch (e) {
      emit(PhieuMuaHangStateDeleteFailure(e.toString()));
    }
  }
}
