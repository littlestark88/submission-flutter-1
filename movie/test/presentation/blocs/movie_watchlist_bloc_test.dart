import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_watchlist_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_bloc.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_event.dart';
import 'package:movie/bloc/watchlistmovie/watchlist_movie_state.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchlistMovies extends Mock implements GetWatchlistMovies {}

void main() {
  late MockGetWatchlistMovies mockGetWatchlistMovies;
  late WatchlistMovieBloc watchlistMovieBloc;

  setUp(() {
    mockGetWatchlistMovies = MockGetWatchlistMovies();
    watchlistMovieBloc =
        WatchlistMovieBloc(mockGetWatchlistMovies);
  });

  group('Movie Bloc, Watchlist Movie:', () {
    test('initialState should be Empty', () {
      expect(watchlistMovieBloc.state, WatchlistMovieEmpty());
    });

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => Right([testWatchlistMovie]));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        WatchlistMovieHasData([testWatchlistMovie])
      ],
      verify: (bloc) => verify(() => mockGetWatchlistMovies.execute()),
    );

    blocTest<WatchlistMovieBloc, WatchlistMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetWatchlistMovies.execute())
            .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
        return watchlistMovieBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistMovie()),
      expect: () => [
        WatchlistMovieLoading(),
        const WatchlistMovieError("Can't get data"),
      ],
      verify: (bloc) => verify(() => mockGetWatchlistMovies.execute()),
    );
  });
}
