import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_watchlist_status_tv.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:core/domain/usecases/save_wahtchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_bloc.dart';
import 'package:tv/bloc/watchlisttvstatus/watchlist_tv_status_state.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetWatchListStatusTV extends Mock implements GetWatchListStatusTv {}

class MockSaveWatchlistTV extends Mock implements SaveWatchlistTv {}

class MockRemoveWatchlistTV extends Mock implements RemoveWatchlistTv {}

void main() {
  late MockGetWatchListStatusTV mockGetWatchListStatusTV;
  late MockSaveWatchlistTV mockSaveWatchlistTV;
  late MockRemoveWatchlistTV mockRemoveWatchlistTV;
  late WatchlistTvStatusBloc watchlistTvStatusBloc;

  setUp(() {
    mockGetWatchListStatusTV = MockGetWatchListStatusTV();
    mockSaveWatchlistTV = MockSaveWatchlistTV();
    mockRemoveWatchlistTV = MockRemoveWatchlistTV();
    watchlistTvStatusBloc = WatchlistTvStatusBloc(
      getWatchListTvStatus: mockGetWatchListStatusTV,
      saveWatchlistTv: mockSaveWatchlistTV,
      removeWatchlistTv: mockRemoveWatchlistTV,
    );
  });

  const tId = 1;

  group('TV Bloc, Get Watchlist Status TV:', () {
    blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
      'should get watchlist true',
      build: () {
        when(() => mockGetWatchListStatusTV.execute(tId)).thenAnswer((_) async => true);
        return watchlistTvStatusBloc;
      },
      act: (bloc) => bloc.loadWatchlistStatus(tId),
      expect: () => [
        WatchlistTvStatusState(isAddedWatchlistTv: true, message: ''),
      ],
    );
  });

  group('TV Bloc, Save Watchlist TV:', () {
    blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
      'should execute save watchlist when function called',
      build: () {
        when(() => mockSaveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Right('Added to Watchlist'));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistTvStatusBloc;
      },
      act: (bloc) => bloc.addWatchlistTv(testTVShowDetail),
      expect: () => [
        WatchlistTvStatusState(
            isAddedWatchlistTv: true, message: 'Added to Watchlist'),
      ],
    );

    blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
      'should update watchlist message when add watchlist failed',
      build: () {
        when(() => mockSaveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistTvStatusBloc;
      },
      act: (bloc) => bloc.addWatchlistTv(testTVShowDetail),
      expect: () => [
        WatchlistTvStatusState(isAddedWatchlistTv: false, message: 'Failed'),
      ],
    );
  });

  group('TV Bloc, Remove Watchlist TV:', () {
    blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
      'should execute remove watchlist when function called',
      build: () {
        when(() => mockRemoveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Right('Removed'));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => true);
        return watchlistTvStatusBloc;
      },
      act: (bloc) => bloc.removeTvWatchlist(testTVShowDetail),
      expect: () => [
        WatchlistTvStatusState(isAddedWatchlistTv: true, message: 'Removed'),
      ],
    );

    blocTest<WatchlistTvStatusBloc, WatchlistTvStatusState>(
      'should update watchlist message when remove watchlist failed',
      build: () {
        when(() => mockRemoveWatchlistTV.execute(testTVShowDetail))
            .thenAnswer((_) async => const Left(DatabaseFailure('Failed')));
        when(() => mockGetWatchListStatusTV.execute(testTVShowDetail.id))
            .thenAnswer((_) async => false);
        return watchlistTvStatusBloc;
      },
      act: (bloc) => bloc.removeTvWatchlist(testTVShowDetail),
      expect: () => [
        WatchlistTvStatusState(isAddedWatchlistTv: false, message: 'Failed'),
      ],
    );
  });
}
