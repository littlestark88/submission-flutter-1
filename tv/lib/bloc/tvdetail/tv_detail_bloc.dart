
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/tvdetail/tv_detail_event.dart';
import 'package:tv/bloc/tvdetail/tv_detail_state.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail _getTvDetail;

  TvDetailBloc(this._getTvDetail) : super(TvDetailEmpty()) {
    on<FetchTvDetail>((event, emit) async {
      final id = event.id;
      emit(TvDetailLoading());
      final result = await _getTvDetail.execute(id);

      result.fold(
            (failure) {
          emit(TvDetailError(failure.message));
        },
            (data) {
          emit(TvDetailHasData(data));
        },
      );
    });
  }
}