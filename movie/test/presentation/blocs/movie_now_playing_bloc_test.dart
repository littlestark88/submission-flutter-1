import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/movie.dart';
import 'package:core/domain/usecases/get_now_playing_movies.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/nowplaying/now_playing_bloc.dart';
import 'package:movie/bloc/nowplaying/now_playing_event.dart';
import 'package:movie/bloc/nowplaying/now_playing_state.dart';

class MockGetNowPlayingMovies extends Mock implements GetNowPlayingMovies {}

void main() {
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;
  late NowPlayingBloc nowPlayingBloc;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    nowPlayingBloc =
        NowPlayingBloc(mockGetNowPlayingMovies);
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

  group('Movie Bloc, Now Playing Movie:', () {
    test('initialState should be Empty', () {
      expect(nowPlayingBloc.state, NowPlayingEmpty());
    });

    blocTest<NowPlayingBloc, NowPlayingState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => Right(tMovieList));
        return nowPlayingBloc;
      },
      act: (bloc) => bloc.add(const FetchNowPlaying()),
      expect: () => [
        NowPlayingLoading(),
        NowPlayingHasData(tMovieList)
      ],
      verify: (bloc) => verify(() => mockGetNowPlayingMovies.execute()),
    );

    blocTest<NowPlayingBloc, NowPlayingState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetNowPlayingMovies.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return nowPlayingBloc;
      },
      act: (bloc) => bloc.add(FetchNowPlaying()),
      expect: () => [
        NowPlayingLoading(),
        const NowPlayingError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetNowPlayingMovies.execute()),
    );
  });
}
