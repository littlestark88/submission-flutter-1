import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/remove_watchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../helper/dummy_data/tv_dummy_objects.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late RemoveWatchlistTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = RemoveWatchlistTv(repository);
  });

  group('TV Use Cases, Remove TV Watchlist:', () {
    test('should remove watchlist movie from repository', () async {
      // arrange
      when(() => repository.removeWatchlistTv(testTvDetail))
          .thenAnswer((_) async => const Right('Removed from Watchlist'));
      // act
      final result = await usecase.execute(testTvDetail);
      // assert
      expect(result, const Right('Removed from Watchlist'));
    });
  });
}
