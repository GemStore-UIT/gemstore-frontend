import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_event.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/bloc/nha_cung_cap_state.dart';
import 'package:gemstore_frontend/features/home/nha_cung_cap/nha_cung_cap_repository.dart';

class NhaCungCapBloc extends Bloc<NhaCungCapEvent, NhaCungCapState> {
  NhaCungCapBloc(this.nhaCungCapRepository) : super(NhaCungCapInitial()) {
    on<NhaCungCapEventStart>(_onStart);
    on<NhaCungCapEventAdd>(_onAdd);
    on<NhaCungCapEventUpdate>(_onUpdate);
    on<NhaCungCapEventDelete>(_onDelete);
    on<NhaCungCapEventGetAll>(_onGetAll);
    on<NhaCungCapEventGetById>(_onGetById);
  }

  final NhaCungCapRepository nhaCungCapRepository;

  void _onStart(
    NhaCungCapEventStart event,
    Emitter<NhaCungCapState> emit,
  ) {
    emit(NhaCungCapInitial());
  } 

  void _onAdd(
    NhaCungCapEventAdd event,
    Emitter<NhaCungCapState> emit,
  ) {
    // Implement add logic here
  }

  void _onUpdate(
    NhaCungCapEventUpdate event,
    Emitter<NhaCungCapState> emit,
  ) {
    // Implement update logic here
  }

  void _onDelete(
    NhaCungCapEventDelete event,
    Emitter<NhaCungCapState> emit,
  ) {
    // Implement delete logic here
  }

  void _onGetAll(
    NhaCungCapEventGetAll event,
    Emitter<NhaCungCapState> emit,
  ) async {
    try {
      emit(NhaCungCapLoading());
      final data = await nhaCungCapRepository.getAll();
      emit(NhaCungCapFetchingSuccess(nhaCungCapRepository.convertToTableRowData(data)));
    } catch (e) {
      emit(NhaCungCapFetchingFailure(e.toString()));
    }
  }

  void _onGetById(
    NhaCungCapEventGetById event,
    Emitter<NhaCungCapState> emit,
  ) async {

  }

}
