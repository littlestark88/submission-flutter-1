import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/bloc/moviedetail/movie_detail_bloc.dart';
import 'package:movie/bloc/moviedetail/movie_detail_event.dart';
import 'package:movie/bloc/moviedetail/movie_detail_state.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetMovieDetail extends Mock implements GetMovieDetail {}

void main() {
  late MockGetMovieDetail mockGetMovieDetail;
  late MovieDetailBloc detailMovieBloc;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    detailMovieBloc = MovieDetailBloc(mockGetMovieDetail);
  });

  const tId = 1;

  group('Movie Bloc, Movie Detail:', () {
    test('initialState should be Empty', () {
      expect(detailMovieBloc.state, MovieDetailEmpty());
    });

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(testMovieDetail));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailHasData(testMovieDetail)
      ],
      verify: (bloc) => verify(() => mockGetMovieDetail.execute(tId)),
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetMovieDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return detailMovieBloc;
      },
      act: (bloc) => bloc.add(const FetchMovieDetail(id: tId)),
      expect: () => [
        MovieDetailLoading(),
        const MovieDetailError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetMovieDetail.execute(tId)),
    );
  });
}
