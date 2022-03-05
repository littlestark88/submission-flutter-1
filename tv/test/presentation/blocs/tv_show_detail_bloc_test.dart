import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/tvdetail/tv_detail_bloc.dart';
import 'package:tv/bloc/tvdetail/tv_detail_event.dart';
import 'package:tv/bloc/tvdetail/tv_detail_state.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockGetTVShowDetail extends Mock implements GetTvDetail {}

void main() {
  late MockGetTVShowDetail mockGetTVShowDetail;
  late TvDetailBloc detailTVBloc;

  setUp(() {
    mockGetTVShowDetail = MockGetTVShowDetail();
    detailTVBloc = TvDetailBloc(mockGetTVShowDetail);
  });

  const tId = 1;

  group('TV Bloc, Get TV Show Detail:', () {
    test('initialState should be Empty', () {
      expect(detailTVBloc.state, TvDetailEmpty());
    });

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => Right(testTVShowDetail));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(id: tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailHasData(testTVShowDetail)
      ],
      verify: (bloc) => verify(() => mockGetTVShowDetail.execute(tId)),
    );

    blocTest<TvDetailBloc, TvDetailState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetTVShowDetail.execute(tId))
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return detailTVBloc;
      },
      act: (bloc) => bloc.add(FetchTvDetail(id: tId)),
      expect: () => [
        TvDetailLoading(),
        TvDetailError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetTVShowDetail.execute(tId)),
    );
  });
}
