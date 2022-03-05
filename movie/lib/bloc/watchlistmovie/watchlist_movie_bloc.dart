import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_event.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_state.dart';

class WatchlistMovieBloc extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies _getWatchlistMovie;

  WatchlistMovieBloc(this._getWatchlistMovie) : super(WatchlistMovieEmpty()) {
    on<FetchWatchlistMovie>((event, emit) async {
      emit(WatchlistMovieLoading());
      final result = await _getWatchlistMovie.execute();

      result.fold(
            (failure) {
          emit(WatchlistMovieError(failure.message));
        },
            (data) {
          emit(WatchlistMovieHasData(data));
        },
      );
    });
  }
}