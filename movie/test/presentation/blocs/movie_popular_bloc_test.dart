import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_popular_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/popularmovie/popular_movie_bloc.dart';
import 'package:movie/bloc/popularmovie/popular_movie_event.dart';
import 'package:movie/bloc/popularmovie/popular_movie_state.dart';

class MockGetPopularMovies extends Mock implements GetPopularMovies {}

void main() {
  late MockGetPopularMovies mockGetPopularMovies;
  late PopularMovieBloc popularMovieBloc;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    popularMovieBloc = PopularMovieBloc(mockGetPopularMovies);
  });

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
  final tMovieList = <Movie>[tMovie];

  group('Movie Bloc, Popular Movie:', () {
    test('initialState should be Empty', () {
      expect(popularMovieBloc.state, PopularMovieEmpty());
    });

    blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetPopularMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovie()),
      expect: () => [
        PopularMovieLoading(),
        PopularMovieHasData(tMovieList)
      ],
      verify: (bloc) => verify(() => mockGetPopularMovies.execute()),
    );

    blocTest<PopularMovieBloc, PopularMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetPopularMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return popularMovieBloc;
      },
      act: (bloc) => bloc.add(FetchPopularMovie()),
      expect: () => [
        PopularMovieLoading(),
        const PopularMovieError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetPopularMovies.execute()),
    );
  });
}
