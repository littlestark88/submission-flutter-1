import 'package:core/domain/entities/movie_detail.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_state.dart';


class WatchlistMovieStatusBloc extends Cubit<WatchlistMovieStatusState> {
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Remove from Watchlist';

  WatchlistMovieStatusBloc({
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(WatchlistMovieStatusState(isAddedWatchlist: false, message: ''));

  void loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    emit(WatchlistMovieStatusState(isAddedWatchlist: result, message: ''));
  }

  Future<void> addWatchlistMovie(MovieDetail movieDetail) async {
    final result = await saveWatchlist.execute(movieDetail);
    final status = await getWatchListStatus.execute(movieDetail.id);

    result.fold((failure) async {
      emit(WatchlistMovieStatusState(
          isAddedWatchlist: status, message: failure.message));
    }, (data) async {
      emit(WatchlistMovieStatusState(isAddedWatchlist: status, message: data));
    });
  }

  Future<void> removeWatchlistMovie(MovieDetail movieDetail) async {
    final result = await removeWatchlist.execute(movieDetail);
    final status = await getWatchListStatus.execute(movieDetail.id);

    result.fold(
            (failure) async {
      emit(WatchlistMovieStatusState(
          isAddedWatchlist: status, message: failure.message));
    }, (data) async {
      emit(WatchlistMovieStatusState(isAddedWatchlist: status, message: data));
    });
  }
}
