import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_tv_recommendations.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetTvRecommendations usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTvRecommendations(repository);
  });

  const tId = 1;
  final tTVShows = <Tv>[];

  group('TV Use Cases, Get TV Recommendation:', () {
    test('should get list of movie recommendations from the repository',
        () async {
      // arrange
      when(() => repository.getTvRecommendations(tId))
          .thenAnswer((_) async => Right(tTVShows));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(tTVShows));
    });
  });
}
