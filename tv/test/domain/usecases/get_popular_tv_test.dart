import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_popular_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetPopularTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetPopularTv(repository);
  });
  final tTV = <Tv>[];

  group('TV Use Cases, Get TV Popular:', () {
    test(
        'should get list popular of tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(() => repository.getPopularTv())
          .thenAnswer((_) async => Right(tTV));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTV));
    });
  });
}
