import 'package:core/domain/entities/tv_detail.dart';
import 'package:core/domain/usecases/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_wahtchlist_tv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_state.dart';

class WatchlistTvStatusBloc extends Cubit<WatchlistTvStatusState> {
  final GetWatchListStatusTv getWatchListTvStatus;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  static const watchlistAddSuccessMessage = 'Added to Watchlist Tv';
  static const watchlistRemoveSuccessMessage = 'Remove from Watchlist Tv';

  WatchlistTvStatusBloc({
    required this.getWatchListTvStatus,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  }) : super(WatchlistTvStatusState(isAddedWatchlistTv: false, message: ''));

  void loadWatchlistStatus(int id) async {
    final result = await getWatchListTvStatus.execute(id);
    emit(WatchlistTvStatusState(isAddedWatchlistTv: result, message: ''));
  }

  Future<void> addWatchlistTv(TvDetail tvDetail) async {
    final result = await saveWatchlistTv.execute(tvDetail);
    final status = await getWatchListTvStatus.execute(tvDetail.id);

    result.fold((failure) async {
      emit(WatchlistTvStatusState(
          isAddedWatchlistTv: status, message: failure.message));
    }, (data) async {
      emit(WatchlistTvStatusState(isAddedWatchlistTv: status, message: data));
    });
  }

  Future<void> removeTvWatchlist(TvDetail tvDetail) async {
    final result = await removeWatchlistTv.execute(tvDetail);
    final status = await getWatchListTvStatus.execute(tvDetail.id);

    result.fold((failure) async {
      emit(WatchlistTvStatusState(
          isAddedWatchlistTv: status, message: failure.message));
    }, (data) async {
      emit(WatchlistTvStatusState(isAddedWatchlistTv: status, message: data));
    });
  }
}