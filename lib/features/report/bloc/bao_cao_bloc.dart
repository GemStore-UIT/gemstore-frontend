import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gemstore_frontend/features/report/bao_cao_repository.dart';
import 'package:gemstore_frontend/features/report/bloc/bao_cao_event.dart';
import 'package:gemstore_frontend/features/report/bloc/bao_cao_state.dart';

class BaoCaoBloc extends Bloc<BaoCaoEvent, BaoCaoState>{
  final BaoCaoRepository baoCaoRepository;

  BaoCaoBloc(this.baoCaoRepository) : super(BaoCaoStateInitial()) {
    on<BaoCaoEventStart>((event, emit) {
      emit(BaoCaoStateLoading());
    });

    on<BaoCaoEventGet>((event, emit) async {
      try {
        emit(BaoCaoStateLoading());
        final data = await baoCaoRepository.getBaoCao(event.thang, event.nam);
        emit(BaoCaoStateSuccess(event.thang, event.nam, data));
      } catch (e) {
        emit(BaoCaoStateError("- Không thể tải báo cáo tháng ${event.thang} năm ${event.nam}: Vui lòng kiểm tra kết nối mạng!"));
      }
    });
  }
}