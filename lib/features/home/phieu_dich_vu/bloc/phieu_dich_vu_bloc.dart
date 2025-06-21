import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_event.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/bloc/phieu_dich_vu_state.dart';
import 'package:gemstore_frontend/features/home/phieu_dich_vu/phieu_dich_vu_repository.dart';

class PhieuDichVuBloc extends Bloc<PhieuDichVuEvent, PhieuDichVuState>{
  PhieuDichVuBloc(this.phieuDichVuRepository)
      : super(PhieuDichVuStateInitial()) {
    on<PhieuDichVuEventStart>(_onStart);
    on<PhieuDichVuEventCreate>(_onCreate);
    on<PhieuDichVuEventGetAll>(_onGetAll);
    on<PhieuDichVuEventDelete>(_onDelete);
    on<PhieuDichVuEventUpdate>(_onUpdate);
  }

  final PhieuDichVuRepository phieuDichVuRepository;

  Future<void> _onStart(
      PhieuDichVuEventStart event, Emitter<PhieuDichVuState> emit) async {
    emit(PhieuDichVuStateInitial());
  }

  Future<void> _onCreate(
      PhieuDichVuEventCreate event, Emitter<PhieuDichVuState> emit) async {
    emit(PhieuDichVuStateLoading());
    try {
      await phieuDichVuRepository.create(
        event.khachhang,
        event.sdt,
        event.chiTiet,
      );
      emit(PhieuDichVuStateUpdated(await phieuDichVuRepository.getAll()));
    } catch (e) {
      emit(PhieuDichVuStateError("- Lỗi tạo phiếu dịch vụ: Vui lòng kiểm tra lại cú pháp!"));
    }
  }

  Future<void> _onGetAll(
      PhieuDichVuEventGetAll event, Emitter<PhieuDichVuState> emit) async {
    emit(PhieuDichVuStateLoading());
    try {
      final data = await phieuDichVuRepository.getAll();
      emit(PhieuDichVuStateUpdated(data));
    } catch (e) {
      emit(PhieuDichVuStateError("- Lỗi lấy danh sách phiếu dịch vụ: Vui lòng kiểm tra kết nối mạng!"));
    }
  }

  Future<void> _onDelete(
      PhieuDichVuEventDelete event, Emitter<PhieuDichVuState> emit) async {
    emit(PhieuDichVuStateLoading());
    try {
      await phieuDichVuRepository.delete(event.soPhieuDV);
      emit(PhieuDichVuStateUpdated(await phieuDichVuRepository.getAll()));
    } catch (e) {
      emit(PhieuDichVuStateError("- Lỗi xóa phiếu dịch vụ: Vui lòng kiểm tra lại cú pháp!"));
    }
  }

  Future<void> _onUpdate(
      PhieuDichVuEventUpdate event, Emitter<PhieuDichVuState> emit) async {
    emit(PhieuDichVuStateLoading());
    try {
      await phieuDichVuRepository.update(
        event.soPhieuDV,
        event.khachhang,
        event.sdt,
        event.chiTiet,
      );
      emit(PhieuDichVuStateUpdated(await phieuDichVuRepository.getAll()));
    } catch (e) {
      emit(PhieuDichVuStateError("- Lỗi cập nhật phiếu dịch vụ: Vui lòng kiểm tra lại cú pháp!"));
    }
  }
}