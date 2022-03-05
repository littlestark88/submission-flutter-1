import 'package:core/common/constants.dart';
import 'package:core/common/ssl_pining.dart';
import 'package:core/common/utils.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/widgets/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/bloc/moviedetail/movie_detail_bloc.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_bloc.dart';
import 'package:movie/bloc/nowplaying/now_playing_bloc.dart';
import 'package:movie/bloc/popularmovie/popular_movie_bloc.dart';
import 'package:movie/bloc/searchmovie/search_bloc.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_bloc.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_bloc.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_bloc.dart';
import 'package:movie/pages/home_movie_page.dart';
import 'package:movie/pages/movie_detail_page.dart';
import 'package:movie/pages/popular_movies_page.dart';
import 'package:movie/pages/search_page.dart';
import 'package:movie/pages/top_rated_movies_page.dart';
import 'package:movie/pages/watchlist_movies_page.dart';
import 'package:provider/provider.dart';
import 'package:tv/bloc/airingtoday/airing_today_bloc.dart';
import 'package:tv/bloc/populartv/popular_tv_bloc.dart';
import 'package:tv/bloc/searchtv/search_tv_bloc.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_bloc.dart';
import 'package:tv/bloc/tvdetail/tv_detail_bloc.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_bloc.dart';
import 'package:tv/bloc/watchlisttv/watch_tv_bloc.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_bloc.dart';
import 'package:tv/page/popular_tv_page.dart';
import 'package:tv/page/search_tv_page.dart';
import 'package:tv/page/top_rated_tv_page.dart';
import 'package:tv/page/tv_detail_page.dart';
import 'package:tv/page/tv_page.dart';
import 'package:tv/page/watchlist_tv_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SSLPining.init();
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<MovieDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<NowPlayingBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<AiringTodayBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvDetailBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<SearchTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TopRatedTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<PopularTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<MovieRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<TvRecommendationBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistTvStatusBloc>(),
        ),
        BlocProvider(
          create: (_) => di.locator<WatchlistMovieStatusBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          colorScheme: kColorScheme,
          primaryColor: kRichBlack,
          accentColor: kMikadoYellow,
          scaffoldBackgroundColor: kRichBlack,
          textTheme: kTextTheme,
        ),
        home: Material(
          child: CustomDrawer(
            content:
            HomeMoviePage(),
          ),
        ),
        navigatorObservers: [routeObserver],
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (_) => HomeMoviePage());
            case PopularMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularMoviesPage());
            case TopRatedMoviesPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedMoviesPage());
            case PopularTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => PopularTvPage());
            case TopRatedTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => TopRatedTvPage());
            case MovieDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => MovieDetailPage(id: id),
                settings: settings,
              );
            case TvDetailPage.ROUTE_NAME:
              final id = settings.arguments as int;
              return MaterialPageRoute(
                builder: (_) => TvDetailPage(id: id),
                settings: settings,
              );
            case SearchPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchPage());
            case SearchTvPage.ROUTE_NAME:
              return CupertinoPageRoute(builder: (_) => SearchTvPage());
            case WatchlistMoviesPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistMoviesPage());
            case WatchlistTvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => WatchlistTvPage());
            case AboutPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => AboutPage());
            case TvPage.ROUTE_NAME:
              return MaterialPageRoute(builder: (_) => TvPage());
            default:
              return MaterialPageRoute(builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Text('Page not found :('),
                  ),
                );
              });
          }
        },
      ),
    );
  }
}
