import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/populartv/popular_tv_bloc.dart';
import 'package:tv/bloc/populartv/popular_tv_event.dart';
import 'package:tv/bloc/populartv/popular_tv_state.dart';

class MockGetPopularTVShows extends Mock implements GetPopularTv {}

void main() {
  late MockGetPopularTVShows mockGetPopularTVShows;
  late PopularTvBloc popularTVBloc;

  setUp(() {
    mockGetPopularTVShows = MockGetPopularTVShows();
    popularTVBloc = PopularTvBloc(mockGetPopularTVShows);
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

  group('TV Bloc, Popular TV Shows:', () {
    test('initialState should be Empty', () {
      expect(popularTVBloc.state, PopularTvEmpty());
    });

    blocTest<PopularTvBloc, PopularTvState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetPopularTVShows.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return popularTVBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        PopularTvLoading(),
        PopularTvHasData(tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetPopularTVShows.execute()),
    );

    blocTest<PopularTvBloc, PopularTvState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetPopularTVShows.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return popularTVBloc;
      },
      act: (bloc) => bloc.add(FetchPopularTv()),
      expect: () => [
        PopularTvLoading(),
        PopularTvError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetPopularTVShows.execute()),
    );
  });
}
