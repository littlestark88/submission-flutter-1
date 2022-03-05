import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_event.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_state.dart';

class TopRatedTvBloc extends Bloc<TopRatedTvEvent, TopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  TopRatedTvBloc(this._getTopRatedTv) : super(TopRatedTvEmpty()) {
    on<FetchTopRatedTv>((event, emit) async {
      emit(TopRatedTvLoading());
      final result = await _getTopRatedTv.execute();

      result.fold(
            (failure) {
          emit(TopRatedTvError(failure.message));
        },
            (data) {
          emit(TopRatedTvHasData(data));
        },
      );
    });
  }
}