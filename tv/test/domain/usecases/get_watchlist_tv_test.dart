import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_watchlist_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';


class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetWatchlistTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetWatchlistTv(repository);
  });

  group('TV Use Cases, Get TV Watchlist:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => repository.getWatchlistTv())
          .thenAnswer((_) async => Right(testTVShowsList));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(testTVShowsList));
    });
  });
}
