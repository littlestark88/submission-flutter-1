import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_bloc.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_event.dart';
import 'package:tv/bloc/tvrecommendation/tv_recommendation_state.dart';

class MockGetTVShowsRecommendation extends Mock
    implements GetTvRecommendations{}

void main() {
  late MockGetTVShowsRecommendation mockGetTVShowsRecommendation;
  late TvRecommendationBloc recommendationTVBloc;

  setUp(() {
    mockGetTVShowsRecommendation = MockGetTVShowsRecommendation();
    recommendationTVBloc = TvRecommendationBloc(mockGetTVShowsRecommendation);
  });

  const tId = 1;
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

  group('TV Bloc, Get Recommendation TV Shows:', () {
    test('initialState should be Empty', () {
      expect(recommendationTVBloc.state, TvRecommendationEmpty());
    });

    blocTest<TvRecommendationBloc, TvRecommendationState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTVShowsRecommendation.execute(tId))
            .thenAnswer((_) async => Right(tTVShowsList));
        return recommendationTVBloc;
      },
      act: (bloc) => bloc.add(FetchTvRecommendation(id: tId)),
      expect: () => [
        TvRecommendationLoading(),
        TvRecommendationHasData(tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetTVShowsRecommendation.execute(tId)),
    );

    blocTest<TvRecommendationBloc, TvRecommendationState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTVShowsRecommendation.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return recommendationTVBloc;
      },
      act: (bloc) => bloc.add(FetchTvRecommendation(id: tId)),
      expect: () => [
        TvRecommendationLoading(),
        TvRecommendationError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTVShowsRecommendation.execute(tId)),
    );
  });
}
