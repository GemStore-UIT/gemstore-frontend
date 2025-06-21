import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_event.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/bloc/phieu_mua_hang_state.dart';
import 'package:gemstore_frontend/features/home/phieu_mua_hang/phieu_mua_hang_repository.dart';

class PhieuMuaHangBloc extends Bloc<PhieuMuaHangEvent, PhieuMuaHangState> {
  PhieuMuaHangBloc(this.phieuMuaHangRepository)
    : super(PhieuMuaHangStateInitial()) {
    on<PhieuMuaHangEventStart>(_onStart);
    on<PhieuMuaHangEventCreate>(_onCreate);
    on<PhieuMuaHangEventGetAll>(_onGetAll);
    on<PhieuMuaHangEventDelete>(_onDelete);
    on<PhieuMuaHangEventUpdate>(_onUpdate);
  }

  final PhieuMuaHangRepository phieuMuaHangRepository;

  void _onStart(PhieuMuaHangEventStart event, Emitter<PhieuMuaHangState> emit) {
    emit(PhieuMuaHangStateInitial());
  }

  void _onCreate(
    PhieuMuaHangEventCreate event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      await phieuMuaHangRepository.create(event.maNCC, event.sanPhamMua);
      final data = await phieuMuaHangRepository.getAll();
      emit(PhieuMuaHangStateUpdated(data));
    } catch (e) {
      emit(PhieuMuaHangStateFailure("- Lỗi tạo phiếu mua hàng: Vui lòng kiểm tra lại cú pháp!"));
    }
  }

  void _onGetAll(
    PhieuMuaHangEventGetAll event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      final data = await phieuMuaHangRepository.getAll();
      emit(PhieuMuaHangStateUpdated(data));
    } catch (e) {
      emit(
        PhieuMuaHangStateFailure(
          "- Lỗi tải danh sách phiếu mua hàng: Vui lòng kiểm tra kết nối mạng!",
        ),
      );
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
      emit(PhieuMuaHangStateUpdated(data));
    } catch (e) {
      emit(PhieuMuaHangStateFailure("- Lỗi xóa phiếu mua hàng: Vui lòng kiểm tra lại cú pháp!"));
    }
  }

  void _onUpdate(
    PhieuMuaHangEventUpdate event,
    Emitter<PhieuMuaHangState> emit,
  ) async {
    try {
      emit(PhieuMuaHangStateLoading());
      await phieuMuaHangRepository.update(event.phieuMuaHang);
      final data = await phieuMuaHangRepository.getAll();
      emit(PhieuMuaHangStateUpdated(data));
    } catch (e) {
      emit(PhieuMuaHangStateFailure("- Lỗi cập nhật phiếu mua hàng: Vui lòng kiểm tra lại cú pháp!"));
    }
  }
}
