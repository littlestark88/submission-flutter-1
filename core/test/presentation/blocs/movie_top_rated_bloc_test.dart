import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_top_rated_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_bloc.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_event.dart';
import 'package:movie/bloc/topratedmovie/top_rated_movie_state.dart';

class MockGetTopRatedMovies extends Mock implements GetTopRatedMovies {}

void main() {
  late MockGetTopRatedMovies mockGetTopRatedMovies;
  late TopRatedMovieBloc topRatedMovieBloc;

  setUp(() {
    mockGetTopRatedMovies = MockGetTopRatedMovies();
    topRatedMovieBloc =
        TopRatedMovieBloc(mockGetTopRatedMovies);
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

  group('Movie Bloc, Top Rated Movie:', () {
    test('initialState should be Empty', () {
      expect(topRatedMovieBloc.state, TopRatedMovieEmpty());
    });

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovie()),
      expect: () => [
        TopRatedMovieLoading(),
        TopRatedMovieHasData(tMovieList)
      ],
      verify: (bloc) => verify(() => mockGetTopRatedMovies.execute()),
    );

    blocTest<TopRatedMovieBloc, TopRatedMovieState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTopRatedMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return topRatedMovieBloc;
      },
      act: (bloc) => bloc.add(FetchTopRatedMovie()),
      expect: () => [
        TopRatedMovieLoading(),
        const TopRatedMovieError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTopRatedMovies.execute()),
    );
  });
}
