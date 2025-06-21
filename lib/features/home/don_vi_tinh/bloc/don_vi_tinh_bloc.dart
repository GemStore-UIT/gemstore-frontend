import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_state.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_repository.dart';

class DonViTinhBloc extends Bloc<DonViTinhEvent, DonViTinhState> {
  DonViTinhBloc(this.donViTinhRepository) : super(DonViTinhStateInitial()) {
    on<DonViTinhEventStart>(_onStart);
    on<DonViTinhEventCreate>(_onCreate);
    on<DonViTinhEventUpdate>(_onUpdate);
    on<DonViTinhEventDelete>(_onDelete);
    on<DonViTinhEventGetAll>(_onGetAll);
  }

  final DonViTinhRepository donViTinhRepository;

  void _onStart(DonViTinhEventStart event, Emitter<DonViTinhState> emit) {
    emit(DonViTinhStateInitial());
  }

  void _onCreate(
    DonViTinhEventCreate event,
    Emitter<DonViTinhState> emit,
  ) async {
    emit(DonViTinhStateLoading());
    try {
      await donViTinhRepository.create(event.tenDonVi);
      add(DonViTinhEventGetAll());
    } catch (error) {
      emit(
        DonViTinhStateFailure(
          "- Không thể tạo đơn vị tính: Vui lòng kiểm tra lại cú pháp!",
        ),
      );
    }
  }

  void _onUpdate(
    DonViTinhEventUpdate event,
    Emitter<DonViTinhState> emit,
  ) async {
    emit(DonViTinhStateLoading());
    try {
      await donViTinhRepository.update(event.maDonVi, event.tenDonVi);
      add(DonViTinhEventGetAll());
    } catch (error) {
      emit(
        DonViTinhStateFailure(
          "- Không thể cập nhật đơn vị tính: Vui lòng kiểm tra lại cú pháp!",
        ),
      );
    }
  }

  void _onDelete(
    DonViTinhEventDelete event,
    Emitter<DonViTinhState> emit,
  ) async {
    emit(DonViTinhStateLoading());
    try {
      await donViTinhRepository.delete(event.maDonVi);
      add(DonViTinhEventGetAll());
    } catch (error) {
      emit(
        DonViTinhStateFailure(
          "- Không thể xóa đơn vị tính: Đơn vị tính có thể đang được sử dụng!",
        ),
      );
    }
  }

  void _onGetAll(
    DonViTinhEventGetAll event,
    Emitter<DonViTinhState> emit,
  ) async {
    try {
      emit(DonViTinhStateLoading());
      final data = await donViTinhRepository.getAll();
      emit(DonViTinhStateUpdated(data));
    } catch (e) {
      emit(
        DonViTinhStateFailure(
          "- Không thể lấy danh sách đơn vị tính: Vui lòng kiểm tra kết nối mạng!",
        ),
      );
    }
  }
}
