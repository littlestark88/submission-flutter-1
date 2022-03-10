import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/save_wahtchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';

class MockTvRepository extends Mock implements TvRepository {}

void main() {
  late SaveWatchlistTv usecase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    usecase = SaveWatchlistTv(mockTvRepository);
  });

  group('Tv Use Cases, Save Tv Watchlist:', () {
    test('should save tv to the repository', () async {
      // arrange
      when(() => mockTvRepository.saveWatchlistTv(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist Tv'));
      // act
      final result = await usecase.execute(testTvDetail);
      // assert
      verify(() => mockTvRepository.saveWatchlistTv(testTvDetail));
      expect(result, const Right('Added to Watchlist Tv'));
    });
  });
}