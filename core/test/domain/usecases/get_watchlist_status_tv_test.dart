import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_watchlist_status_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';


class MockTvRepository extends Mock implements TvRepository {}

void main() {
  late GetWatchListStatusTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = GetWatchListStatusTv(mockTvRepository);
  });

  const tId = 1;

  group('Tv Use Cases, Get Tv Watchlist Status:', () {
    test('should get watchlist status from repository', () async {
      // arrange
      when(() => mockTvRepository.isAddedToWatchlistTv(tId))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    });
  });
}