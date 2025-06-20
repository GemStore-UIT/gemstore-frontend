import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/bloc/phieu_ban_hang_state.dart';
import 'package:gemstore_frontend/features/home/phieu_ban_hang/phieu_ban_hang_repository.dart';

class PhieuBanHangBloc extends Bloc<PhieuBanHangEvent, PhieuBanHangState> {
  PhieuBanHangBloc(this.phieuBanHangRepository)
    : super(PhieuBanHangStateInitial()) {
    on<PhieuBanHangEventStart>(_onStart);
    on<PhieuBanHangEventCreate>(_onCreate);
    on<PhieuBanHangEventGetAll>(_onGetAll);
    on<PhieuBanHangEventDelete>(_onDelete);
    on<PhieuBanHangEventUpdate>(_onUpdate);
  }

  final PhieuBanHangRepository phieuBanHangRepository;

  void _onStart(PhieuBanHangEventStart event, Emitter<PhieuBanHangState> emit) {
    emit(PhieuBanHangStateInitial());
  }

  void _onCreate(
    PhieuBanHangEventCreate event,
    Emitter<PhieuBanHangState> emit,
  ) async {
    emit(PhieuBanHangStateLoading());
    try {
      await phieuBanHangRepository.create(event.khachHang, event.sanPhamBan);
      add(PhieuBanHangEventGetAll());
    } catch (e) {
      emit(PhieuBanHangStateFailure("Lỗi tạo phiếu bán hàng: ${e.toString()}"));
    }
  }

  void _onGetAll(
    PhieuBanHangEventGetAll event,
    Emitter<PhieuBanHangState> emit,
  ) async {
    emit(PhieuBanHangStateLoading());
    try {
      final data = await phieuBanHangRepository.getAll();
      emit(PhieuBanHangStateUpdated(data));
    } catch (e) {
      emit(
        PhieuBanHangStateFailure(
          "Lỗi lấy danh sách phiếu bán hàng: ${e.toString()}",
        ),
      );
    }
  }

  void _onDelete(
    PhieuBanHangEventDelete event,
    Emitter<PhieuBanHangState> emit,
  ) async {
    emit(PhieuBanHangStateLoading());
    try {
      await phieuBanHangRepository.delete(event.soPhieu);
      add(PhieuBanHangEventGetAll());
    } catch (e) {
      emit(PhieuBanHangStateFailure("Lỗi xóa phiếu bán hàng: ${e.toString()}"));
    }
  }

  void _onUpdate(
    PhieuBanHangEventUpdate event,
    Emitter<PhieuBanHangState> emit,
  ) async {
    emit(PhieuBanHangStateLoading());
    try {
      await phieuBanHangRepository.update(
        event.soPhieuBH,
        event.khachHang,
        event.sanPhamBan,
      );
      add(PhieuBanHangEventGetAll());
    } catch (e) {
      emit(
        PhieuBanHangStateFailure(
          "Lỗi cập nhật phiếu bán hàng: ${e.toString()}",
        ),
      );
    }
  }
}
