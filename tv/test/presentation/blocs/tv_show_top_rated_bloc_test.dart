import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_bloc.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_event.dart';
import 'package:tv/bloc/topratedtv/top_rated_tv_state.dart';

class MockGetTopRatedTVShows extends Mock implements GetTopRatedTv {}

void main() {
  late MockGetTopRatedTVShows mockGetTopRatedTVShows;
  late TopRatedTvBloc topRatedTVBloc;

  setUp(() {
    mockGetTopRatedTVShows = MockGetTopRatedTVShows();
    topRatedTVBloc = TopRatedTvBloc(mockGetTopRatedTVShows);
  });

  final tTVShow = Tv(
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'name',
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    voteAverage: 1.0,
    voteCount: 1,
  );

  final tTVShowsList = <Tv>[tTVShow];

  group('TV Bloc, Top Rated TV Shows:', () {
    test('initialState should be Empty', () {
      expect(topRatedTVBloc.state, TopRatedTvEmpty());
    });

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTopRatedTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return topRatedTVBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvHasData(tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetTopRatedTVShows.execute()),
    );

    blocTest<TopRatedTvBloc, TopRatedTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTopRatedTVShows.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return topRatedTVBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedTv()),
      expect: () => [
        TopRatedTvLoading(),
        TopRatedTvError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTopRatedTVShows.execute()),
    );
  });
}
