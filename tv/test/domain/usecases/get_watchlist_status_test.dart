
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_watchlist_status_tv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetWatchListStatusTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetWatchListStatusTv(repository);
  });

  group('TV Use Cases, Get TV Watchlist Status:', () {
    test('should get watchlist status from repository', () async {
      // arrange
      when(() => repository.isAddedToWatchlistTv(1))
          .thenAnswer((_) async => true);
      // act
      final result = await usecase.execute(1);
      // assert
      expect(result, true);
    });
  });
}
