import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_wahtchlist_tv.dart';
import 'package:flutter/cupertino.dart';

import '../../domain/entities/tv.dart';
import '../../domain/usecases/get_watchlist_status_tv.dart';

class TvDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatusTv getWatchListStatusTv;
  final SaveWatchlistTv saveWatchlistTv;
  final RemoveWatchlistTv removeWatchlistTv;

  TvDetailNotifier({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatusTv,
    required this.saveWatchlistTv,
    required this.removeWatchlistTv,
  });

  late TvDetail _tv;
  TvDetail get tv => _tv;

  RequestState _tvState = RequestState.Empty;
  RequestState get tvState => _tvState;

  List<Tv> _tvRecommendations = [];
  List<Tv> get tvRecommendations => _tvRecommendations;

  RequestState _recommendationsState = RequestState.Empty;
  RequestState get recommendationsState => _recommendationsState;

  String _message = '';
  String get message => _message;

  bool _isAddedToWatchlist = false;
  bool get isAddedToWatchlist => _isAddedToWatchlist;

  Future<void> fetchTvDetail(int id) async {
    _tvState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getTvDetail.execute(id);
    final recommendationResult = await getTvRecommendations.execute(id);
    detailResult.fold(
        (failure) {
          _tvState = RequestState.Error;
          _message = failure.message;
          notifyListeners();
        },
        (dataTv) {
          _recommendationsState = RequestState.Loading;
          _tv = dataTv;
          notifyListeners();
          recommendationResult.fold(
              (failure) {
                _recommendationsState = RequestState.Error;
                _message = failure.message;
              },
              (data) {
                _recommendationsState = RequestState.Loaded;
                _tvRecommendations = data;
              },
          );
          _tvState = RequestState.Loaded;
          notifyListeners();
        },
    );
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(TvDetail tv) async {
    final result = await saveWatchlistTv.execute(tv);

    await result.fold(
        (failure) async {
          _watchlistMessage = failure.message;
        },
        (successMessage) async {
          _watchlistMessage = successMessage;
        },
    );
    await loadWatchlistStatus(tv.id);
  }

  Future<void> removeFromWatchlist(TvDetail tvDetail) async {
    final result = await removeWatchlistTv.execute(tvDetail);

    await result.fold(
        (failure) async {
          _watchlistMessage = failure.message;
        },
        (successMessage) async {
          _watchlistMessage = successMessage;
        },
    );
    await loadWatchlistStatus(tvDetail.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatusTv.execute(id);
    _isAddedToWatchlist = result;
    notifyListeners();
  }

}