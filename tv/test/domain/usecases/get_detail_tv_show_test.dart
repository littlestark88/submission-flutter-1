import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_tv_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helper/dummy_data/dummy_objects.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetTvDetail usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTvDetail(repository);
  });

  const tId = 1;

  group('TV Use Cases, Get TV Detail:', () {
    test('should get tv show detail from the repository', () async {
      // arrange
      when(() => repository.getTvDetail(tId))
          .thenAnswer((_) async => Right(testTVShowDetail));
      // act
      final result = await usecase.execute(tId);
      // assert
      expect(result, Right(testTVShowDetail));
    });
  });
}
