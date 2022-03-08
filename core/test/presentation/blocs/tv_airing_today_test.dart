import 'package:bloc_test/bloc_test.dart';
import 'package:core/common/failure.dart';
import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/usecases/get_airing_today_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tv/bloc/airingtoday/airing_today_bloc.dart';
import 'package:tv/bloc/airingtoday/airing_today_event.dart';
import 'package:tv/bloc/airingtoday/airing_today_state.dart';

class MockGetAiringTodayTv extends Mock implements GetAiringTodayTv {}

void main() {
  late MockGetAiringTodayTv mockGetAiringToday;
  late AiringTodayBloc airingTodayBloc;

  setUp(() {
    mockGetAiringToday = MockGetAiringTodayTv();
    airingTodayBloc = AiringTodayBloc(mockGetAiringToday);
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

  group('TV Bloc, Airing Today:', () {
    test('initialState should be Empty', () {
      expect(airingTodayBloc.state, AiringTodayEmpty());
    });

    blocTest<AiringTodayBloc, AiringTodayState>(
      'should emit[Loading, HasData] when data is gotten successfully',
      build: () {
        when(() => mockGetAiringToday.execute())
            .thenAnswer((_) async => Right(tTVShowsList));
        return airingTodayBloc;
      },
      act: (bloc) => bloc.add(FetchAiringToday()),
      expect: () => [
        AiringTodayLoading(),
        AiringTodayHasData(tTVShowsList)
      ],
      verify: (bloc) => verify(() => mockGetAiringToday.execute()),
    );

    blocTest<AiringTodayBloc, AiringTodayState>(
      'should emit [Loading, Error] when get data is unsuccessful',
      build: () {
        when(() => mockGetAiringToday.execute())
            .thenAnswer((_) async => const Left(ServerFailure('Server Failure')));
        return airingTodayBloc;
      },
      act: (bloc) => bloc.add(FetchAiringToday()),
      expect: () => [
        AiringTodayLoading(),
        AiringTodayError('Server Failure'),
      ],
      verify: (bloc) => verify(() => mockGetAiringToday.execute()),
    );
  });
}
