import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_movie_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_bloc.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_event.dart';
import 'package:movie/bloc/movierecommendation/movie_recommendation_state.dart';

class MockGetMovieRecommendations extends Mock
    implements GetMovieRecommendations {}

void main() {
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MovieRecommendationBloc recommendationMovieBloc;

  setUp(() {
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    recommendationMovieBloc = MovieRecommendationBloc(mockGetMovieRecommendations);
  });

  const tId = 1;
  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: const [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  group('Movie Bloc, Recommendation Movie', () {
    test('initialState should be Empty', () {
      expect(recommendationMovieBloc.state, MovieRecommendationEmpty());
    });

    blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetMovieRecommendations.execute(tId))
            .thenAnswer((_) async => Right(tMovies));
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendation(id: tId)),
      expect: () => [
        MovieRecommendationLoading(),
        MovieRecommendationHasData(tMovies)
      ],
      verify: (bloc) => verify(() => mockGetMovieRecommendations.execute(tId)),
    );

    blocTest<MovieRecommendationBloc, MovieRecommendationState>(
      'Should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetMovieRecommendations.execute(tId)).thenAnswer(
            (_) async => const Left(ServerFailure('Server Failure')));
        return recommendationMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieRecommendation(id: tId)),
      expect: () => [
        MovieRecommendationLoading(),
        const MovieRecommendationError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetMovieRecommendations.execute(tId)),
    );
  });
}
