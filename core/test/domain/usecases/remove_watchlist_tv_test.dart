import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';

class MockTvRepository extends Mock implements TvRepository {}

void main() {
  late RemoveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = RemoveWatchlistTv(mockTvRepository);
  });

  group('Tv Use Cases, Remove Tv Watchlist:', () {
    test('should remove watchlist tv from repository', () async {
      // arrange
      when(() => mockTvRepository.removeWatchlistTv(testTvDetail))
          .thenAnswer((_) async => const Right('Removed from watchlist'));
      // act
      final result = await usecase.execute(testTvDetail);
      // assert
      verify(() => mockTvRepository.removeWatchlistTv(testTvDetail));
      expect(result, const Right('Removed from watchlist'));
    });
  });
}