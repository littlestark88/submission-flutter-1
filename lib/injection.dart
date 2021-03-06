import 'package:core/common/network_info.dart';
import 'package:core/common/ssl_pining.dart';
import 'package:core/data/datasources/db/database_helper.dart';
import 'package:core/data/datasources/movie_local_data_source.dart';
import 'package:core/data/datasources/movie_remote_data_source.dart';
import 'package:core/data/datasources/tv_local_data_source.dart';
import 'package:core/data/datasources/tv_remote_data_source.dart';
import 'package:core/data/repositories/movie_repository_impl.dart';
import 'package:core/data/repositories/tv_repository_impl.dart';
import 'package:core/domain/repositories/movie_repository.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_airing_today_tv.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_wahtchlist_tv.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:core/domain/usecases/search_movies.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:data_connection_checker/data_connection_checker.dart';


import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie/bloc/moviedetail/movie_detail_bloc.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_bloc.dart';
import 'package:movie/bloc/nowplaying/now_playing_bloc.dart';
import 'package:movie/bloc/popularmovie/popular_movie_bloc.dart';
import 'package:movie/bloc/searchmovie/search_bloc.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_bloc.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_bloc.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_bloc.dart';
import 'package:tv/bloc/airingtoday/airing_today_bloc.dart';
import 'package:tv/bloc/populartv/popular_tv_bloc.dart';
import 'package:tv/bloc/searchtv/search_tv_bloc.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_bloc.dart';
import 'package:tv/bloc/tvdetail/tv_detail_bloc.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_bloc.dart';
import 'package:tv/bloc/watchlisttv/watch_tv_bloc.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_bloc.dart';

final locator = GetIt.instance;

void init() {
  locator.registerFactory(
    () => MovieDetailBloc(locator()),
  );

  locator.registerFactory(
    () => TvDetailBloc(locator()),
  );

  locator.registerFactory(
    () => TopRatedMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => SearchBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => SearchTvBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => NowPlayingBloc(locator()),
  );

  locator.registerFactory(
    () => PopularMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => AiringTodayBloc(locator()),
  );

  locator.registerFactory(
    () => PopularTvBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => TopRatedTvBloc(locator()),
  );

  locator.registerFactory(
    () => MovieRecommendationBloc(locator()),
  );

  locator.registerFactory(
    () => TvRecommendationBloc(locator()),
  );

  locator.registerFactory(
    () => WatchlistMovieBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistTvBloc(
      locator(),
    ),
  );

  locator.registerFactory(
    () => WatchlistMovieStatusBloc(
        getWatchListStatus: locator(),
        saveWatchlist: locator(),
        removeWatchlist: locator()),
  );

  locator.registerFactory(
    () => WatchlistTvStatusBloc(
      getWatchListTvStatus: locator(),
      removeWatchlistTv: locator(),
      saveWatchlistTv: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));

  locator.registerLazySingleton(() => GetAiringTodayTv(locator()));
  locator.registerLazySingleton(() => GetPopularTv(locator()));
  locator.registerLazySingleton(() => GetTopRatedTv(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendations(locator()));
  locator.registerLazySingleton(() => SearchTv(locator()));
  locator.registerLazySingleton(() => GetWatchListStatusTv(locator()));
  locator.registerLazySingleton(() => SaveWatchlistTv(locator()));
  locator.registerLazySingleton(() => RemoveWatchlistTv(locator()));
  locator.registerLazySingleton(() => GetWatchlistTv(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
      () => MovieRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<MovieLocalDataSource>(
      () => MovieLocalDataSourceImpl(databaseHelper: locator()));

  locator.registerLazySingleton<TvRemoteDataSource>(
      () => TvRemoteDataSourceImpl(client: locator()));
  locator.registerLazySingleton<TvLocalDataSource>(
      () => TvLocalDataSourceImpl(databaseHelper: locator()));

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => SSLPining.client);
  locator.registerLazySingleton(() => DataConnectionChecker());
}
