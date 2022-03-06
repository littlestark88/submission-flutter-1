import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/save_wahtchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/tv_dummy_objects.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late SaveWatchlistTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = SaveWatchlistTv(repository);
  });

  group('TV Use Cases, Save TV Watchlist:', () {
    test('should save movie to the repository', () async {
      // arrange
      when(() => repository.saveWatchlistTv(testTvDetail))
          .thenAnswer((_) async => const Right('Added to Watchlist'));
      // act
      final result = await usecase.execute(testTvDetail);
      // assert
      expect(result, const Right('Added to Watchlist'));
    });
  });
}
