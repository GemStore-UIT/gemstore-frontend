import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_state.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_repository.dart';

class NhaCungCapBloc extends Bloc<NhaCungCapEvent, NhaCungCapState> {
  NhaCungCapBloc(this.nhaCungCapRepository) : super(NhaCungCapStateInitial()) {
    on<NhaCungCapEventStart>(_onStart);
    on<NhaCungCapEventCreate>(_onCreate);
    on<NhaCungCapEventUpdate>(_onUpdate);
    on<NhaCungCapEventDelete>(_onDelete);
    on<NhaCungCapEventGetAll>(_onGetAll);
  }

  final NhaCungCapRepository nhaCungCapRepository;

  void _onStart(
    NhaCungCapEventStart event,
    Emitter<NhaCungCapState> emit,
  ) {
    emit(NhaCungCapStateInitial());
  }

  void _onCreate(
    NhaCungCapEventCreate event,
    Emitter<NhaCungCapState> emit,
  ) async {
    emit(NhaCungCapStateLoading());
    try {
      await nhaCungCapRepository.create(event.tenNCC, event.diaChi, event.sdt);
      add(NhaCungCapEventGetAll());
    } catch (error) {
      emit(NhaCungCapStateFailure("- Không thể tạo nhà cung cấp: Vui lòng kiểm tra lại cú pháp!"));
    }
  }

  void _onUpdate(
    NhaCungCapEventUpdate event,
    Emitter<NhaCungCapState> emit,
  ) async {
    emit(NhaCungCapStateLoading());
    try {
      await nhaCungCapRepository.update(event.nhaCungCap);
      add(NhaCungCapEventGetAll());
    } catch (error) {
      emit(NhaCungCapStateFailure("- Không thể cập nhật nhà cung cấp: Vui lòng kiểm tra lại cú pháp!"));
    }
  }

  void _onDelete(
    NhaCungCapEventDelete event,
    Emitter<NhaCungCapState> emit,
  ) async {
    emit(NhaCungCapStateLoading());
    try {
      await nhaCungCapRepository.delete(event.maNCC);
      add(NhaCungCapEventGetAll());
    } catch (error) {
      emit(NhaCungCapStateFailure("- Không thể xóa nhà cung cấp: Nhà cung cấp có thể đang được sử dụng!"));
    }
  }

  void _onGetAll(
    NhaCungCapEventGetAll event,
    Emitter<NhaCungCapState> emit,
  ) async {
    try {
      emit(NhaCungCapStateLoading());
      final data = await nhaCungCapRepository.getAll();
      emit(NhaCungCapStateUpdated(data));
    } catch (e) {
      emit(NhaCungCapStateFailure("- Không thể lấy danh sách nhà cung cấp: Vui lòng kiểm tra kết nối mạng!"));
    }
  }
}
