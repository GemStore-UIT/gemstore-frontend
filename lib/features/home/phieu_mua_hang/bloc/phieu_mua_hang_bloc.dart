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
        event.ngayLap,
        event.thanhTien,
        event.sanPhamMua,
      );
      final data = await phieuMuaHangRepository.getAll();
      final listSanPham = await phieuMuaHangRepository.getListSanPham();
      emit(
        PhieuMuaHangStateSuccess(
          phieuMuaHangRepository.convertToTableRowData(data),
          listSanPham,
        ),
      );
    } catch (e) {
      emit(PhieuMuaHangStateFailure(e.toString()));
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
      emit(
        PhieuMuaHangStateSuccess(
          phieuMuaHangRepository.convertToTableRowData(data),
          listSanPham,
        ),
      );
    } catch (e) {
      emit(PhieuMuaHangStateFailure(e.toString()));
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
}
