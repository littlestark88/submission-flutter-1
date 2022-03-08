import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/search_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late SearchTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = SearchTv(repository);
  });

  const tQuery = 'Titan';
  final tTVShows = <Tv>[];

  group('TV Use Cases, Get TV Search:', () {
    test('should get list of movies from the repository', () async {
      // arrange
      when(() => repository.searchTv(tQuery))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tQuery);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
