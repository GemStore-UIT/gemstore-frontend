import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/adjust/bloc/tham_so_event.dart';
import 'package:gemstore_frontend/features/adjust/bloc/tham_so_state.dart';
import 'package:gemstore_frontend/features/adjust/tham_so_repository.dart';

class ThamSoBloc extends Bloc<ThamSoEvent, ThamSoState> {
  final ThamSoRepository thamSoRepository;

  ThamSoBloc(this.thamSoRepository) : super(ThamSoStateInitial()) {
    on<ThamSoEventStart>((event, emit) {
      emit(ThamSoStateInitial());
    });

    on<ThamSoEventGetAll>((event, emit) async {
      emit(ThamSoStateLoading());
      try {
        final thamSoList = await thamSoRepository.getAll();
        emit(ThamSoStateLoaded(thamSoList));
      } catch (e) {
        emit(ThamSoStateError('- Không thể tải danh sách tham số: Vui lòng kiểm tra kết nối mạng!'));
      }
    });

    on<ThamSoEventUpdate>((event, emit) async {
      emit(ThamSoStateLoading());
      try {
        await thamSoRepository.updateThamSo(event.tenThamSo, event.giaTri);
        add(ThamSoEventGetAll());
      } catch (e) {
        emit(ThamSoStateError('- Không thể cập nhật tham số: Vui lòng kiểm tra lại cú pháp!'));
      }
    });
  }
}
