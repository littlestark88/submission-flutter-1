import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/watchlisttv/watchlist_tv_event.dart';
import 'package:tv/bloc/watchlisttv/watchlist_tv_state.dart';

class WatchlistTvBloc extends Bloc<WatchlistTvEvent, WatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;

  WatchlistTvBloc(this._getWatchlistTv) : super(WatchlistTvEmpty()) {
    on<FetchWatchlistTv>((event, emit) async {
      emit(WatchlistTvLoading());
      final result = await _getWatchlistTv.execute();

      result.fold(
            (failure) {
          emit(WatchlistTvError(failure.message));
        },
            (data) {
          emit(WatchlistTvHasData(data));
        },
      );
    });
  }
}