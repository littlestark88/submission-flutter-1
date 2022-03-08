import 'package:core/domain/entities/tv.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/domain/usecases/get_top_rated_tv.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTVRepository extends Mock implements TvRepository {}

void main() {
  late GetTopRatedTv usecase;
  late MockTVRepository repository;

  setUp(() {
    repository = MockTVRepository();
    usecase = GetTopRatedTv(repository);
  });
  final tTV = <Tv>[];

  group('TV Use Cases, Get TV Top Rated:', () {
    test(
        'should get list top rated of tv shows from the repository when execute function is called',
        () async {
      // arrange
      when(() => repository.getTopRatedTv())
          .thenAnswer((_) async => Right(tTV));
      // act
      final result = await usecase.execute();
      // assert
      expect(result, Right(tTV));
    });
  });
}
