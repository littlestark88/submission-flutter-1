import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_watchlist_status.dart';
import 'package:core/domain/usecases/remove_watchlist.dart';
import 'package:core/domain/usecases/save_watchlist.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_bloc.dart';
import 'package:movie/bloc/watchliststatusmovie/watchlist_movie_status_state.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchListStatus extends Mock implements GetWatchListStatus {}

class MockSaveWatchlist extends Mock implements SaveWatchlist {}

class MockRemoveWatchlist extends Mock implements RemoveWatchlist {}

void main() {
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlist mockSaveWatchlist;
  late MockRemoveWatchlist mockRemoveWatchlist;
  late WatchlistMovieStatusBloc watchlistMovieStatusBloc;

  setUp(() {
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlist = MockSaveWatchlist();
    mockRemoveWatchlist = MockRemoveWatchlist();
    watchlistMovieStatusBloc = WatchlistMovieStatusBloc(
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlist,
      removeWatchlist: mockRemoveWatchlist,
    );
  });

  const tId = 1;

  group('Movie Bloc, Watchlist Status Movie:', () {
    blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatus.execute(tId))
            .thenAnswer((_) async => true);
        return watchlistMovieStatusBloc;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        const WatchlistMovieStatusState(isAddedWatchlist: true, message: ''),
      ],
    );
  });

  group('Movie Bloc, Save Watchlist Movie:', () {
    blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistMovieStatusBloc;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistMovieStatusState(
            isAddedWatchlist: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistMovieStatusBloc;
      },
      act: (bloc) => bloc.addWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistMovieStatusState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });

  group('Movie Bloc, Remove Watchlist Movie:', () {
    blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => true);
        return watchlistMovieStatusBloc;
      },
      act: (bloc) => bloc.removeWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistMovieStatusState(isAddedWatchlist: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistMovieStatusBloc, WatchlistMovieStatusState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlist.execute(testMovieDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatus.execute(testMovieDetail.id))
            .thenAnswer((_) async => false);
        return watchlistMovieStatusBloc;
      },
      act: (bloc) => bloc.removeWatchlistMovie(testMovieDetail),
      expect: () => [
        const WatchlistMovieStatusState(isAddedWatchlist: false, message: 'Failed'),
      ],
    );
  });
}
