import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_event.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/bloc/don_vi_tinh_state.dart';
import 'package:gemstore_frontend/features/home/don_vi_tinh/don_vi_tinh_repository.dart';

class DonViTinhBloc extends Bloc<DonViTinhEvent, DonViTinhState> {
  DonViTinhBloc(this.donViTinhRepository) : super(DonViTinhInitial()) {
    on<DonViTinhEventStart>(_onStart);
    on<DonViTinhEventAdd>(_onAdd);
    on<DonViTinhEventUpdate>(_onUpdate);
    on<DonViTinhEventDelete>(_onDelete);
    on<DonViTinhEventGetAll>(_onGetAll);
    on<DonViTinhEventGetById>(_onGetById);
  }

  final DonViTinhRepository donViTinhRepository;

  void _onStart(
    DonViTinhEventStart event,
    Emitter<DonViTinhState> emit,
  ) {
    emit(DonViTinhInitial());
  }

  void _onAdd(
    DonViTinhEventAdd event,
    Emitter<DonViTinhState> emit,
  ) {
    // Implement add logic here
  }

  void _onUpdate(
    DonViTinhEventUpdate event,
    Emitter<DonViTinhState> emit,
  ) {
    // Implement update logic here
  }

  void _onDelete(
    DonViTinhEventDelete event,
    Emitter<DonViTinhState> emit,
  ) {
    // Implement delete logic here
  }

  void _onGetAll(
    DonViTinhEventGetAll event,
    Emitter<DonViTinhState> emit,
  ) async {
    try {
      emit(DonViTinhLoading());
      final data = await donViTinhRepository.getAll();
      emit(DonViTinhFetchingSuccess(donViTinhRepository.convertToTableRowData(data)));
    } catch (e) {
      emit(DonViTinhFetchingFailure(e.toString()));
    }
  }

  void _onGetById(
    DonViTinhEventGetById event,
    Emitter<DonViTinhState> emit,
  ) async {
    
  }

}
