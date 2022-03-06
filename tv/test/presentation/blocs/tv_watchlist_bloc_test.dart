import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/watchlisttv/watch_tv_bloc.dart';
import 'package:tv/bloc/watchlisttv/watchlist_tv_event.dart';
import 'package:tv/bloc/watchlisttv/watchlist_tv_state.dart';
import '../../helper/dummy_data/tv_dummy_objects.dart';

class MockGetWatchlistTVShows extends Mock implements GetWatchlistTv {}

void main() {
  late MockGetWatchlistTVShows mockGetWatchlistTVShows;
  late WatchlistTvBloc watchlistTVBloc;

  setUp(() {
    mockGetWatchlistTVShows = MockGetWatchlistTVShows();
    watchlistTVBloc =
        WatchlistTvBloc(mockGetWatchlistTVShows);
  });

  group('TV Bloc, Watchlist TV Shows:', () {
    test('initialState should be Empty', () {
      expect(watchlistTVBloc.state, WatchlistTvEmpty());
    });

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetWatchlistTVShows.execute())
            .thenAnswer((_) async => Right([testWatchlistTv]));
        return watchlistTVBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvHasData([testWatchlistTv])
      ],
      verify: (bloc) => verify(() => mockGetWatchlistTVShows.execute()),
    );

    blocTest<WatchlistTvBloc, WatchlistTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetWatchlistTVShows.execute())
            .thenAnswer((_) async => const Left(DatabaseFailure("Can't get data")));
        return watchlistTVBloc;
      },
      act: (bloc) => bloc.add(FetchWatchlistTv()),
      expect: () => [
        WatchlistTvLoading(),
        WatchlistTvError("Can't get data"),
      ],
      verify: (bloc) => verify(() => mockGetWatchlistTVShows.execute()),
    );
  });
}
