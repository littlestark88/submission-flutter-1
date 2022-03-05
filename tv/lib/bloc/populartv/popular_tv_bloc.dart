import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/populartv/popular_tv_event.dart';
import 'package:tv/bloc/populartv/popular_tv_state.dart';

class PopularTvBloc extends Bloc<PopularTvEvent, PopularTvState> {
  final GetPopularTv _getPopularTv;

  PopularTvBloc(this._getPopularTv) : super(PopularTvEmpty()) {
    on<FetchPopularTv>((event, emit) async {
      emit(PopularTvLoading());
      final result = await _getPopularTv.execute();

      result.fold(
            (failure) {
          emit(PopularTvError(failure.message));
        },
            (data) {
          emit(PopularTvHasData(data));
        },
      );
    });
  }
}